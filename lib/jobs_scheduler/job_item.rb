require_relative "error_handler"

module JobsScheduler
  # Returns an object of job item with node and it's child
  class JobItem
    attr_accessor :child, :node

    def initialize(child, node = nil)
      @child = child
      @node = node

      assert_child_differs_from_node
    end

    def assert_child_differs_from_node
      ErrorHandler.new([child, node]).call if child == node
    end
  end
end
