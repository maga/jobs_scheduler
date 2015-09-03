module JobsScheduler
  class ErrorHandler
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def call
      raise(ArgumentError, "Error: #{message}")
    end

    private

    def message
      case error
      when Array
        argument = error.join(",").gsub(",", " => ")
        "jobs cannot depend on themselves #{argument}"
      when KeyError
        error.message
      when TSort::Cyclic
        argument = Array.class_eval(error.message[/\[.+\]/]).join(",").gsub(",", " => ")
        "jobs cannot have circular dependencies #{argument}"
      end
    end
  end
end
