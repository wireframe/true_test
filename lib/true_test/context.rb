module TrueTest
  class Context
    attr_accessor :setup
    class << self
      def current
        @@context ||= TrueTest::Context.new
        @@context
      end
    end

    def setup_fixtures(binding, keys)
      keys.each do |key|
        self.evaluate binding do
          fixtures << TrueTest::Fixture.evaluate(key, binding)
        end
      end
    end
    def fixtures
      @fixtures ||= []
      @fixtures
    end
    def teardown(binding)
      @fixtures.each do |fixture|
        fixture.unbind binding
      end
      @fixtures.clear
      @@context = nil
    end
    def description
      parts = []
      parts += ['when', @setup] if @setup
      parts += ['with', fixtures.collect(&:description).join(' and ')] if fixtures.any?
      parts.join(' ')
    end
    #safe evaluation that creates a failed test if an exception is raised instead of blowing up entire suite
    def evaluate(binding, &block)
      TrueTest::PositiveAssertion.new('not raise error', &block).evaluate binding
    end
  end
end
