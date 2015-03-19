require 'thor'
require_relative 'generator/project'
require_relative 'generator/project/check_test_run'

class CLI < Thor
  include TestRail
  desc "perform", "Creates project for interaction with TestRail"

  def perform
    TestRail::Generators::Project.copy_file('run_test_run.rb')
    TestRail::Generators::Project.copy_file("test_rail_data.yml", "config/data/")
  end

  desc "check_test_run_and_update", "Check test run statuses and update"

  def check_test_run_and_update
    TestRail::Check.check_test_run_statuses
  end
end

