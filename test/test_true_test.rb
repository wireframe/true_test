require File.join(File.dirname(__FILE__), 'helper')
require File.join(File.dirname(__FILE__), '..', 'lib', 'true_test', 'compatibility', 'test_unit')

class TestTrueTest < Test::Unit::TestCase
  # declare fixtures
  class User
    def do_something
      @did_something = true
    end
    def did_something?
      @did_something
    end
    def did_something_else?
      @did_something_else
    end
    def blow_up!
      raise 'holy crap!'
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
  register_fixture :a_bad_fixture do
    raise 'boom!'
  end

  #write tests
  with :a_basic_user, :a_basic_blog do
    setup 'executing @a_basic_user.do_something' do
      @a_basic_user.do_something
    end

    should 'define @a_basic_user' do
      defined? @a_basic_user
    end
    should 'define @a_basic_blog' do
      defined? @a_basic_user
    end
    should 'have did_something?' do
      @a_basic_user.did_something?
    end
    should_not 'have did_something_else?' do
      @a_basic_user.did_something_else?
    end
    should 'have done some other stuff, but not yet implemented'
  end

  with :a_basic_user do
    setup 'executing @a_basic_user.blow_up!' do
      @a_basic_user.blow_up!
    end

    should 'error out before getting here, but not break the whole suite'
  end

  with :a_bad_fixture do
    should 'error out before getting here, but not break the whole suite'
  end
end
