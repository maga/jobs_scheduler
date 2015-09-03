require_relative "tsortable_jobs"
require_relative "error_handler"

module JobsScheduler
  class Orderer < Hash
    def initialize(jobs_hash)
      @jobs_hash = jobs_hash
    end

    def call
      TsortableJobs[@jobs_hash].tsort
    rescue => error
      ErrorHandler.new(error).call
    end
  end
end
