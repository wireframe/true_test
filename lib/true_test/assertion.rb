module TrueTest
  class Assertion
    def initialize(description = nil, positive = true, &block)
      @description = description
      @positive = positive
      @block = block || proc {false}
    end
    def evaluate
      @passed = false
      begin
        @result = TrueTest::Context.current.evaluate(&@block)
        @passed = @positive ? @result : !@result
      rescue => e
        @error = e
      end
    ensure
      TrueTest.after_assertion_callbacks.each do |callback|
        callback.call(self)
      end
    end
    def passed?
      @passed
    end
    def error
      @error
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
