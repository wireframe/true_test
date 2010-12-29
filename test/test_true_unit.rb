require File.join(File.dirname(__FILE__), 'helper')

class TestTrueUnit < Test::Unit::TestCase
  def self.register(key, &block)
    attr_accessor key
    (class << self; self end).send(:define_method, key) do
      result = yield
      instance_variable_set "@#{key}", result
    end
  end

  register :basic_user do
    'foo'
  end

  def self.with(scope = nil, &block)
    yield
  end


  #########################
  
  with basic_user do
    puts @basic_user
  end
end
