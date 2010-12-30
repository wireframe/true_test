module TrueUnit
  module DSL
    def register_fixture(key, &block)
      attr_accessor key
      (class << self; self end).send(:define_method, key) do
        TrueUnit::Context.current.fixtures << key
        result = yield
        instance_variable_set "@#{key}", result
        self
      end
    end

    def with(fixtures, &block)
      yield
    ensure
      TrueUnit::Context.current.fixtures.each do |fixture|
        instance_variable_set "@#{fixture}", nil
      end
      TrueUnit::Context.current.teardown
      @@execution = nil
    end

    def execute(description = nil, &block)
      @@execution = description
      yield
    end

    def asserts(description = nil, &block)
      @@assertion = description
      puts test_sentence
      result = yield
      raise Test::Unit::AssertionFailedError.new(test_sentence) unless result
    ensure
      @@assertion = nil
    end

    def test_sentence
      ['assert', @@assertion, 'when executing', @@execution, TrueUnit::Context.current.description].join(' ')
    end
  end
end
