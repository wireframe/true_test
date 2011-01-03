module TrueTest
  class Context
    class << self
      def current
        @@context ||= TrueTest::Context.new
        @@context
      end
    end

    def fixtures
      @fixtures ||= []
      @fixtures
    end
    def teardown
      @fixtures.clear
      @@context = nil
    end
    def evaluate(&block)
      self.instance_eval(&block)
    end
    def description
      parts = []
      parts += ['when executing', @setup] if @setup
      parts += ['with', fixtures.collect(&:description).join(' and ')] if fixtures.any?
      parts.join(' ')
    end

    def setup(description = nil, &block)
      @setup = description
      evaluate &block
    end

    def should(description = nil, &block)
      assertion = TrueTest::PositiveAssertion.new(description, &block)
      puts assertion.description
      assertion.evaluate
    end
    def should_not(description = nil, &block)
      assertion = TrueTest::NegativeAssertion.new(description, &block)
      puts assertion.description
      assertion.evaluate
    end
  end
end
