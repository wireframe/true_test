module TrueUnit
  module DSL
    def metaclass
      (class << self; self end)
    end
    def register_fixture(key, &block)
      attr_accessor key
      metaclass.send(:define_method, key) do
        TrueUnit::Context.current.fixtures << key
        result = TrueUnit::Context.current.evaluate &block
        TrueUnit::Context.current.instance_variable_set "@#{key}", result
        self
      end
    end

    def with(fixtures, &block)
      TrueUnit::Context.current.evaluate &block
    ensure
      TrueUnit::Context.current.fixtures.each do |fixture|
        instance_variable_set "@#{fixture}", nil
      end
      TrueUnit::Context.current.teardown
    end
  end
end
