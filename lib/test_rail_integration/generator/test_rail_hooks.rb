require 'test_rail_integration/generator/connection'

module TestRail
  class Hook

    #
    # Updating Test Rail according to logic
    #
    def self.update_test_rail(scenario)
      TestRail::TestCaseResult.new(scenario).update
    end

    at_exit do
      TestRail::Connection.change_test_run_name until ENV['rspec-tests-running']
    end
  end
end
