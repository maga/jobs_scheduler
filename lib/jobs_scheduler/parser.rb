require_relative "job_item"

module JobsScheduler
  # Parses a job list from input to tree-like hash
  class Parser
    attr_reader :jobs_list

    def initialize(jobs_list)
      @jobs_list = jobs_list
    end

    def call
      jobs_to_tree
    end

    private

    def jobs_to_tree
      jobs_list.first.strip.split("\n")
        .map(&method(:parse_jobs))
        .map(&method(:strip_jobs))
        .each_with_object({}) do |jobs_chain, hash|
          job = JobItem.new(*jobs_chain)
          hash[job.child] = job.node ? [job.node] : []
        end
    end

    def parse_jobs(jobs_dependency)
      jobs_dependency.split('=>')
    end

    def strip_jobs(jobs_pair)
      jobs_pair.map(&:strip)
    end
  end
end
