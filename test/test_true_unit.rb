require File.join(File.dirname(__FILE__), 'helper')

class TestTrueUnit < Test::Unit::TestCase
  def self.register(key, &block)
    attr_accessor key
    (class << self; self end).send(:define_method, key) do
      result = yield
      instance_variable_set "@#{key}", result
      self
    end
  end

  def self.with(scope = nil, &block)
    yield
  end

  def self.when
  end

  class User
  end
  register :basic_user do
    User.new
  end

  class Blog
  end
  register :basic_blog do
    Blog.new
  end


  #########################
  
  with basic_user.basic_blog do
    puts @basic_user.inspect
    puts @basic_blog.inspect
  end
end
