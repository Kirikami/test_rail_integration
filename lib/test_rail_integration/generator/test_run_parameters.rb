require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:ventures]
    ENVIRONMENT_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:environments]
    CHECK_TEST_RUN_NAME ||= TestRail::TestRailDataLoad.test_rail_data[:check_test_run_name]
    EXEC_COMMAND ||= TestRail::TestRailDataLoad.test_rail_data[:exec_command]

    attr_accessor :environment, :venture, :command

    #
    # Checking of correct naming of created test run and return parameters for running test run
    #
    def initialize(venture, env, command = nil)
      if venture
        self.venture = venture if venture.match(/(#{VENTURE_REGEX})/)
      end
      if env
        self.environment = env if env.match(/(#{ENVIRONMENT_REGEX})/)
      end
      self.command = EXEC_COMMAND
      self.command = command if command
    end
  end
end