require 'thor'
require_relative 'generator/project'
require_relative 'generator/project/check'

class CLI < Thor
  include TestRail

  desc "perform", "Creates project for interaction with TestRail"
  def perform
    TestRail::Generators::Project.copy_file('run_test_run.rb')
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
end

