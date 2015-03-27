require 'test_rail_integration/generator/connection'

module TestRail
  class Hook

    #
    # Updating Test Rail according to logic
    #
    def self.update_test_rail(scenario)
      TestRail::TestCaseResult.new(scenario).update
    end

  end
end
