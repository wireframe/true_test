require File.join(File.dirname(__FILE__), 'helper')

module TrueUnit
  module DSL
    @@fixtures = []
    def register_fixture(key, &block)
      attr_accessor key
      (class << self; self end).send(:define_method, key) do
        @@fixtures << key
        result = yield
        instance_variable_set "@#{key}", result
        self
      end
    end

    def with(fixtures, &block)
      yield
    ensure
      @@fixtures.each do |fixture|
        instance_variable_set "@#{fixture}", nil
      end
      @@fixtures = []
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
      context = ['assert', @@assertion, 'when executing', @@execution]
      context += ['with', @@fixtures.join(' and ')] if @@fixtures && @@fixtures.any?
      context.join(' ')
    end
  end

  include TrueUnit::DSL
end

class TestTrueUnit < Test::Unit::TestCase
  extend TrueUnit

  puts self.methods.sort.inspect
  # declare fixtures
  class User
    def do_something
      @did_something = true
    end
    def did_something?
      @did_something
    end
  end
  class Blog
  end
  register_fixture :a_basic_user do
    User.new
  end
  register_fixture :a_basic_blog do
    Blog.new
  end

  #write tests
  with a_basic_user.a_basic_blog do
    execute '@a_basic_user.do_something' do
      @a_basic_user.do_something
    end
    asserts 'did something' do
      @a_basic_user.did_something?
    end
  end
end
