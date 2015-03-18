require 'thor'
require_relative 'generator/project'

module TestRailIntegration
  class CLI < Thor
    desc "perform", "Creates project for interaction with TestRail"

    def perform
      TestRailIntegration::TestRail::Generators::Project.copy_file('run_test_run.rb')
      TestRailIntegration::TestRail::Generators::Project.copy_file("test_rail_data.yml", "config/data/")
    end

    def check_test_run_and_update
      check
    end
  end
end