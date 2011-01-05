module TrueTest
  module DSL
    def register_fixture(key, &block)
      TrueTest::Fixture.register key, &block
    end

    def with(*fixtures, &block)
      fixtures.each do |key|
        TrueTest::Fixture.evaluate key, self
      end
      yield
    ensure
      TrueTest::Context.current.teardown self
    end

    def setup(description = nil, &block)
      TrueTest::Context.current.setup = description
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
