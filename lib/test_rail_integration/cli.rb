require 'thor'
require_relative 'generator/project'

module TestRailIntegration
  class CLI < Thor
    desc "perform", "Creates project for interaction with TestRail"

    def perform
      TestRailIntegration::TestRail::Generators::Project.copy_file('run_test_run.rb')
      TestRailIntegration::TestRail::Generators::Project.copy_file("test_rail_data.yml", "config/data/")
    end

    desc "check_test_run_and_update", "Check test run statuses and update"

    def check_test_run_and_update
      check
    end
  end
end