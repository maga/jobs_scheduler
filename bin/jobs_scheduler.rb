require "jobs_scheduler/runner"

runner = JobsScheduler::Runner.new(ARGV)
runner.run
