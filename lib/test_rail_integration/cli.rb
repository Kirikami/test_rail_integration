require 'thor'
require_relative 'generator/project'
require_relative 'generator/project/check'
require_relative 'generator/test_run'
require_relative 'generator/command'

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
       --command with new command,
       --auto for getting env, venture params from test run name,
       --simple for run without venture and env params,
       --type to define tests with type to execute."
  option :test_run_id
  option :venture
  option :showroom
  option :command
  option :env
  option :auto
  option :simple
  option :type
  def shoot
    if options[:test_run_id]
      test_run_id = options[:test_run_id]
      Connection.test_run_id = test_run_id
      TestRailTools.write_test_run_id(test_run_id)
      command = TestRail::Command.new(test_run_id)
      if options[:auto]
        parameters = TestRail::TestRun.get_by_id(test_run_id).name.downcase.match(/(#{TestRunParameters::VENTURE_REGEX}) (#{TestRunParameters::ENVIRONMENT_REGEX})*/)
        if parameters.nil?
          puts "Your test run name is not correct. It don't contain venture, env params. Please provide correct name for test run on test rail side."
          return
        end
        if parameters[1].nil?
          puts "Your test run name is not correct. It don't contain venture param. Please provide correct name for test run on test rail side."
          return
        end
        if parameters[2].nil?
          puts "Your test run name is not correct. It don't contain env param. Please provide correct name for test run on test rail side."
          return
        end
        if parameters
          # TODO venture can be everything
          if options[:venture]
            command.venture = options[:venture]
          else
            command.venture = parameters[1]
          end
          command.env = parameters[2]
        end
      elsif options[:simple] && !options[:command]
        puts "You should add command param to execute simple execution"
        return
      elsif !options[:simple] && !options[:command]
        if options[:venture].nil? && options[:env].nil?
          puts "You must set correct env, venture params through --env, --venture in order to execute command"
          return
        end
        if options[:venture].nil?
          puts "You must set correct venture param through --venture in order to execute command"
          return
        end
        if options[:env].nil?
          puts "You must set correct env param through --env in order to execute command"
          return
        end
        command.venture = options[:venture]
        command.env = options[:env]
      end
      if options[:env] == "showroom" && options[:showroom]
        command.env = command.env + " SR='#{options[:showroom]}'"
      end
      if options[:command]
        command.command = options[:command]
      else
        command.command = TestRunParameters::EXEC_COMMAND
      end
      if options[:type]
        command.type = options[:type]
      end
      command.generate
      command.execute
    else
      puts "You must set correct test run id through --test_run_id"
    end
  end
end

