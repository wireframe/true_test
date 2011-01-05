module TrueTest
  class Context
    attr_accessor :setup
    class << self
      def current
        @@context ||= TrueTest::Context.new
        @@context
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
  end
end
