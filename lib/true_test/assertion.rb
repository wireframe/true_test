module TrueTest
  class Assertion
    def initialize(description = nil, positive = true, &block)
      @description = description
      @positive = positive
      @block = block || proc {false}
    end
    def evaluate
      result = TrueTest::Context.current.evaluate(&@block)
      if @positive
        raise Test::Unit::AssertionFailedError.new(description) unless result
      else
        raise Test::Unit::AssertionFailedError.new(description) if result
      end
    end
    def description
      [(@positive ? 'should' : 'should not'), @description, TrueTest::Context.current.description].join(' ')
    end
  end

  class PositiveAssertion < Assertion
    def initialize(description = nil, &block)
      super(description, true, &block)
    end
  end

  class NegativeAssertion < Assertion
    def initialize(description = nil, &block)
      super(description, false, &block)
    end
  end
end
