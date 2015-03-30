require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRailTools

    #
    # Method generates executable cucumber file
    #
    # generate_cucumber_execution_file(2)
    #
    # cucumber -p profile.vn.live_test TESTRAIL=1 --color -f json -o cucumber.json -t  @C666,@C777,@C555
    #
    # change this method for create your own cucumber executable
    #
    def self.run_cucumber_command(id_of_run, env = nil)
      parameters = TestRunParameters.new(env)
      #TODO do smth with weird replacement
      command = parameters.command.gsub("\#{parameters.venture}", parameters.venture).gsub("\#{parameters.environment}", parameters.environment) + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      p command
      exec("#{command}")
    end

    #
    # Writing test run ID into test rail data file
    #
    def self.write_test_run_id(test_run_id)
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:test_run_id:.*/, ":test_run_id: #{test_run_id}")
      config_file = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
    end

    #
    # Writing executable command for running
    #
    def self.write_executable_command(command)
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:exec_command:.*/, ":exec_command: #{command}")
      config_file = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
    end
    #
    # Preparation for create right cucumber executable file
    #
    def self.prepare_config(run_id, env = nil)
      Connection.test_run_id = run_id
      write_test_run_id(run_id)
      run_cucumber_command(run_id, env)
    end
  end
end

