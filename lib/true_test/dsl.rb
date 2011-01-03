module TrueTest
  module DSL
    def metaclass
      (class << self; self end)
    end
    def register_fixture(key, &block)
      TrueTest::Fixture.new(key, self, &block)
    end
    def with(fixtures, &block)
      TrueTest::Context.current.evaluate &block
    ensure
      TrueTest::Context.current.fixtures.each do |fixture|
        fixture.unbind
      end
      TrueTest::Context.current.teardown
    end
  end
end
