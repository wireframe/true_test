module TrueUnit
  class Context
    class << self
      def current
        @@context ||= TrueUnit::Context.new
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
      parts += ['with', fixtures.join(' and ').gsub('_', ' ')] if fixtures.any?
      parts.join(' ')
    end

    def setup(description = nil, &block)
      @setup = description
      evaluate &block
    end

    def should(description = nil, &block)
      assertion = TrueUnit::PositiveAssertion.new(description, &block)
      puts assertion.description
      assertion.evaluate
    end
    def should_not(description = nil, &block)
      assertion = TrueUnit::NegativeAssertion.new(description, &block)
      puts assertion.description
      assertion.evaluate
    end

  end
end
