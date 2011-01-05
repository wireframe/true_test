module TrueTest
  module DSL
    def register_fixture(key, &block)
      TrueTest::Fixture.register key, &block
    end

    def current_context
      TrueTest::Context.current
    end
    def with(*fixtures, &block)
      current_context.setup_fixtures self, fixtures
      current_context.evaluate self, &block
      current_context.teardown self
    end

    def setup(description = nil, &block)
      current_context.setup = description
      yield
    end

    def should(description = nil, &block)
      TrueTest::PositiveAssertion.new(description, &block).evaluate self
    end
    def should_not(description = nil, &block)
      TrueTest::NegativeAssertion.new(description, &block).evaluate self
    end

  end
end
