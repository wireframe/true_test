module TrueTest
  class Fixture
    attr_accessor :key, :block
    class << self
      def register(key, &block)
        registry[key] = TrueTest::Fixture.new(key, &block)
      end
      def evaluate(key, binding)
        fixture = registry[key]
        raise "No fixture found in registry with key #{key}: #{registry.keys.inspect}" unless fixture
        fixture.evaluate binding
      end
      def registry
        @@registry ||= {}
        @@registry
      end
    end
    def initialize(key, &block)
      @key = key
      @block = block
    end
    def description
      @key.to_s.gsub('_', ' ')
    end
    def evaluate(binding)
      TrueTest::Context.current.fixtures << self
      @result = binding.instance_eval &@block
      binding.instance_variable_set "@#{@key}", @result
    end
    def unbind(binding)
      binding.instance_variable_set "@#{@key}", nil
    end
  end
end
