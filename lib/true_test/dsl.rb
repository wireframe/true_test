module TrueTest
  module DSL
    def metaclass
      (class << self; self end)
    end
    def register_fixture(key, &block)
      TrueTest::Fixture.register key, &block
    end
    def with(*fixtures, &block)
      fixtures.each do |key|
        TrueTest::Fixture.evaluate key
      end
      TrueTest::Context.current.evaluate &block
    ensure
      TrueTest::Context.current.fixtures.each do |fixture|
        fixture.unbind
      end
      TrueTest::Context.current.teardown
    end
  end
end
