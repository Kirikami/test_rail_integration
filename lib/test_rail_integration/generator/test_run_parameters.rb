require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:ventures]
    ENVIRONMENT_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:environments]
    CHECK_TEST_RUN_NAME ||= TestRail::TestRailDataLoad.test_rail_data[:check_test_run_name]
    EXEC_COMMAND ||= TestRail::TestRailDataLoad.test_rail_data[:exec_command]
  end
end