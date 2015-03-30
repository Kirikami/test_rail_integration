require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRailTools

    #
    # Method generates executable command
    #
    # cucumber -p profile.vn.live_test TESTRAIL=1 --color -f json -o cucumber.json -t  @C666,@C777,@C555
    #
    # change this method for create your own cucumber executable
    #
    def self.generate_executable_command(id_of_run, env = nil, command = nil)
      parameters = TestRunParameters.new(env, command)
      #TODO do smth with weird replacement
      command = parameters.command.gsub("\#{parameters.venture}", parameters.venture).gsub("\#{parameters.environment}", parameters.environment) + " " + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      p command
      run_cucumber(command)
    end

    def self.run_cucumber(command)
      # exec("#{command}")
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
    # Preparation for create right cucumber executable file
    #
    def self.prepare_config(run_id, env = nil, command = nil)
      Connection.test_run_id = run_id
      write_test_run_id(run_id)
      generate_executable_command(run_id, env, command)
    end
  end
end

