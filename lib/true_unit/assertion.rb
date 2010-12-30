module TrueUnit
  class Assertion
    def initialize(description = nil, positive = true, &block)
      @description = description
      @positive = positive
      @block = block || proc {false}
    end
    def evaluate
      result = TrueUnit::Context.current.evaluate(&@block)
      raise Test::Unit::AssertionFailedError.new(test_sentence) unless result
    end
    def description
      ["*", (@positive ? 'should' : 'should not'), @description, TrueUnit::Context.current.description].join(' ')
    end
  end

  class PositiveAssertion < Assertion
    def initialize(description = nil, &block)
      super(description, true, &block)
    end
  end
end
