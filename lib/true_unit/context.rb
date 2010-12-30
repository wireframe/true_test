module TrueUnit
  class Context
    def fixtures
      @fixtures ||= []
      @fixtures
    end
    def teardown
      @fixtures.clear
      @@context = nil
    end
    class << self
      def current
        @@context ||= TrueUnit::Context.new
        @@context
      end
    end
  end
end
