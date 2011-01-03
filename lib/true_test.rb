require File.join(File.dirname(__FILE__), 'true_test', 'context')
require File.join(File.dirname(__FILE__), 'true_test', 'assertion')
require File.join(File.dirname(__FILE__), 'true_test', 'fixture')
require File.join(File.dirname(__FILE__), 'true_test', 'dsl')

module TrueTest
  class << self
    def after_assertion(&block)
      after_assertion_callbacks << block
    end
    def after_assertion_callbacks
      @@after_assertion_callbacks ||= []
      @@after_assertion_callbacks
    end
  end
end
