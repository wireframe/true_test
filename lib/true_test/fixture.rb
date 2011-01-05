module TrueTest
  class Fixture
    attr_accessor :key, :block
    class << self
      def register(key, &block)
        registry[key] = TrueTest::Fixture.new(key, &block)
      end
      def evaluate(key)
        fixture = registry[key]
        raise "No fixture found in registry with key #{key}: #{registry.keys.inspect}" unless fixture
        fixture.evaluate
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
    def evaluate
      TrueTest::Context.current.fixtures << self
      @result = TrueTest::Context.current.evaluate &@block
      TrueTest::Context.current.instance_variable_set "@#{@key}", @result
    end
    def unbind
      TrueTest::Context.current.instance_variable_set "@#{@key}", nil
    end
  end
end

class Object
  def metaclass
    (class << self; self end)
  end
end

class Hash
  def to_mod
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key do
          value
        end
      end
    end
  end
end
