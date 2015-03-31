require 'thor'
require_relative 'generator/project'
require_relative 'generator/project/check'

class CLI < Thor
  include TestRail

  desc "perform", "Creates project for interaction with TestRail"
  def perform
    TestRail::Generators::Project.copy_file("test_rail_data.yml", "config/data/")
  end

  desc "check_test_run_and_update", "Check test run statuses and update. Set test run id through --test_run_id parameter"
  option :test_run_id
  def check_test_run_and_update
    if options[:test_run_id]
      TestRail::Check.check_test_run_statuses(options[:test_run_id])
    else
      puts "You must set correct test run id through --test_run_id"
    end
  end

  desc "shoot", "Run Test Rail integration with \n
       --test_run_id for run id,\n
        optional:
       --venture for describing venture\n
       --showroom with showroom name where start tests
       --command with new command"
  option :test_run_id
  option :venture
  option :showroom
  option :command
  def shoot
    if options[:test_run_id]
      run_id = options[:test_run_id]
      name_of_environment = Connection.test_run_name(run_id).downcase.match(/(#{TestRunParameters::VENTURE_REGEX}) (#{TestRunParameters::ENVIRONMENT_REGEX})*/)
      environment_for_run = name_of_environment[1], name_of_environment[2] if name_of_environment
      environment_for_run[0] = options[:venture] if options[:venture]
      if name_of_environment[2] == "showroom"
        environment_for_run[1] = environment_for_run[1] + " SR = '#{options[:showroom]}'"
      end
      command = options[:command] if options[:command]
      TestRailTools.prepare_and_execute_config(run_id, environment_for_run, command)
    else
      puts "You must set correct test run id through --test_run_id"
    end

  end

end

