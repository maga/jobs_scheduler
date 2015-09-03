require "jobs_scheduler/handler"

module JobsScheduler
  class Runner
    def initialize(argv)
      @argv = argv
    end

    def run
      # return if [@argv, @argv.first].any?(&:empty?)

      jobs_sequence = Handler.new(@argv).call
      unless jobs_sequence
        puts "Arguments are empty. Please, set any job"
        return
      end

      puts "Make your job in the following order: #{jobs_sequence.join(", ")}"
    rescue => error
      puts error
    end
  end
end
