class Test::Unit::TestCase
  extend TrueTest::DSL

  TrueTest.after_assertion do |assertion|
    test_name = ['test', assertion.description].join(' ').to_sym
    self.send(:define_method, test_name) do
      assert assertion.passed?
    end
  end
end
