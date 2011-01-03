module TrueTest
  class Fixture
    attr_accessor :key, :binding, :block
    def initialize(key, binding, &block)
      @key = key
      @block = block
      @binding = binding

      create_accessor_method
    end
    def create_accessor_method
      fixture = self
      @binding.metaclass.send(:define_method, @key) do
        fixture.evaluate
      end
    end
    def description
      @key.to_s.gsub('_', ' ')
    end
    def evaluate
      TrueTest::Context.current.fixtures << self
      @result = TrueTest::Context.current.evaluate &@block
      TrueTest::Context.current.instance_variable_set "@#{@key}", @result
      @binding
    end
    def unbind
      binding.instance_variable_set "@#{@key}", nil
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
