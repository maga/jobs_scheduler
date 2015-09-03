require_relative "../lib/jobs_scheduler/handler"

describe JobsScheduler::Handler do
  context "when args are empty" do
    it "returns nil" do
      handler = jobs_handler([])
      expect(handler.call).to be_nil
    end

    it "returns nil" do
      handler = jobs_handler([""])
      expect(handler.call).to be_nil
    end
  end

  context "when args are invalid" do
    it "raises key not found error" do
      handler = jobs_handler(["a => b"])
      message = 'Error: key not found: "b"'
      expect { handler.call }.to raise_error(ArgumentError, message)
    end

    it "raises key not found error" do
      handler = jobs_handler(["a =>\nb =>\nc => c"])
      message = "Error: jobs cannot depend on themselves c => c"
      expect { handler.call }.to raise_error(ArgumentError, message)
    end

    it "raises circular dependency error" do
      handler = jobs_handler(["a =>\nb => c\nc => f\nd => a\ne =>\nf => b"])
      message = "Error: jobs cannot have circular dependencies b => c => f"
      expect { handler.call }.to raise_error(ArgumentError, message)
    end
  end

  context "when args are valid" do
    let(:message) { "Make your job in the following order: " }
    let(:valid_args) { [["a =>"],
                       ["a =>\nb =>\nc => "],
                       ["a =>\nb => c\nc =>"],
                       ["a =>\nb => c\nc => f\nd => a\ne => b\nf =>"]] }
    it "returns job a" do
      expect(jobs_handler(["a =>"]).call).to eq(%w(a))
    end

    it "returns jobs ordered a b c" do
      expect(jobs_handler(["a =>\nb =>\nc => "]).call).to eq(%w(a b c))
    end

    it "returns jobs ordered a b c" do
      expect(jobs_handler(["a =>\nb =>\nc => "]).call).to eq(%w(a b c))
    end

    it "returns jobs ordered a c b" do
      expect(jobs_handler(["a =>\nb => c\nc =>"]).call).to eq(%w(a c b))
    end

    it "returns jobs ordered a f c b d e" do
      expect(jobs_handler(["a =>\nb => c\nc => f\nd => a\ne => b\nf =>"]).call).to eq(%w(a f c b d e))
    end
  end

  def jobs_handler(args)
    JobsScheduler::Handler.new(args)
  end
end
