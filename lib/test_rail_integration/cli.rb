require 'thor'
require_relative 'generator/project'
require_relative 'generator/project/check'
require_relative 'generator/test_run'

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

  desc "create_test_run", "Create test run with name. Set test run name through --test_run_name parameter"
  option :test_run_name
  def create_test_run
    test_run_name = options[:test_run_name]
    if test_run_name
      if test_run_name == ''
        puts "Test_run_name parameter should not be empty"
      else
        test_run = TestRail::TestRun.create(test_run_name)
        puts "You successfully created test run with id #{test_run.id}"
      end
    else
      puts "You must set correct test run name through --test_run_name\n"
    end
  end

  desc "shoot", "Run Test Rail integration with \n
       --test_run_id for run id,
        optional:
       --venture for describing venture,
       --env for describing environment for run,
       --showroom with showroom name where start tests,
       --command with new command"
  option :test_run_id
  option :venture
  option :showroom
  option :command
  option :env
  def shoot
    if options[:test_run_id]
      run_id = options[:test_run_id]
      parameters = TestRail::TestRun.get_by_id(run_id).name.downcase.match(/(#{TestRunParameters::VENTURE_REGEX}) (#{TestRunParameters::ENVIRONMENT_REGEX})*/)
      venture, env = nil
      if parameters
        venture = parameters[1]
        env = parameters[2]
      end
      venture = options[:venture] if options[:venture]
      env = options[:env] if options[:env]
      if env == "showroom"
        if options[:showroom]
          env = env + " SR='#{options[:showroom]}'"
        else
          env = env
        end
      end
      command = options[:command] if options[:command]
      test_run_parameters = TestRunParameters.new(venture, env, command)
      Connection.test_run_id = run_id
      TestRailTools.write_test_run_id(run_id)
      command = TestRail::TestRailTools.generate_executable_command(run_id, test_run_parameters.venture,
                                                                    test_run_parameters.environment,
                                                                    test_run_parameters.command)
      TestRailTools.execute_command(command)
    else
      puts "You must set correct test run id through --test_run_id"
    end
  end
end

