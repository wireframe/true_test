require File.join(File.dirname(__FILE__), 'helper')

class TestTrueUnit < Test::Unit::TestCase
  @@fixtures = []
  def self.register(key, &block)
    attr_accessor key
    (class << self; self end).send(:define_method, key) do
      @@fixtures << key
      result = yield
      instance_variable_set "@#{key}", result
      self
    end
  end

  def self.with(fixtures, &block)
    yield
  ensure
    @@fixtures = []
    @@execution = nil
  end
  def self.execute(message = nil, &block)
    @@execution = message
    yield
  end
  def self.asserts(message = nil, &block)
    @@assertion = message
    result = yield
    raise Test::Unit::AssertionFailedError.new(test_sentence) unless result
  ensure
    @@assertion = nil
  end
  def self.test_sentence
    ['assert', @@assertion, 'when executing', @@execution, 'with', @@fixtures.join(' and ')].join(' ')
  end

  # declare fixtures
  class User
    def do_something
      puts 'doing something'
    end
  end
  class Blog
  end
  register :a_basic_user do
    User.new
  end
  register :a_basic_blog do
    Blog.new
  end

  #write tests
  with a_basic_user.a_basic_blog do
    execute '@a_basic_user.do_something' do
      @a_basic_user.do_something
    end
    asserts 'did something' do
      false
    end
  end
end
