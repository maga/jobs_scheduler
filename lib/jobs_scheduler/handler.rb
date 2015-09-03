require_relative "parser"
require_relative "orderer"

module JobsScheduler
  # Handles input options and arranges the scheduling process
  class Handler
    attr_reader :jobs_list

    def initialize(argv = "")
      @jobs_list = argv
    end

    def call
      return if (jobs_list.empty? || jobs_list.first.empty?)
      parse_jobs
    end

    private

    def parse_jobs
      parsed_jobs = Parser.new(jobs_list).call
      order_jobs(parsed_jobs)
    end

    def order_jobs(jobs)
      Orderer.new(jobs).call
    end
  end
end
