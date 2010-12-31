module TrueTest
  module DSL
    def metaclass
      (class << self; self end)
    end
    def register_fixture(key, &block)
      attr_accessor key
      metaclass.send(:define_method, key) do
        TrueTest::Context.current.fixtures << key
        result = TrueTest::Context.current.evaluate &block
        TrueTest::Context.current.instance_variable_set "@#{key}", result
        self
      end
    end

    def with(fixtures, &block)
      TrueTest::Context.current.evaluate &block
    ensure
      TrueTest::Context.current.fixtures.each do |fixture|
        instance_variable_set "@#{fixture}", nil
      end
      TrueTest::Context.current.teardown
    end
  end
end
