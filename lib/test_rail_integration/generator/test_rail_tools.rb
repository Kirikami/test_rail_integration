require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRailTools

    #
    # Writing test run ID into test rail data file
    #
    def self.write_test_run_id(test_run_id)
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:test_run_id:.*/, ":test_run_id: #{test_run_id}")
      config_file = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
      test_run_id
    end
  end
end

