module TrueUnit
  class Context
    class << self
      def current
        @@context ||= TrueUnit::Context.new
        @@context
      end
    end

    def fixtures
      @fixtures ||= []
      @fixtures
    end
    def teardown
      @fixtures.clear
      @@context = nil
    end
    def description
      fixtures.any? ? ['with', fixtures.join(' and ').gsub('_', ' ')] : ''
    end
  end
end
