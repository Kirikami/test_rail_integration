module TestRail

  class Command

    attr_accessor :command

    def initialize(id_of_run ,test_run_parameters)
      #TODO do smth with weird replacement
      self.command = test_run_parameters.command.gsub("\#{parameters.venture}", test_run_parameters.venture).gsub("\#{parameters.environment}", test_run_parameters.environment) + " " + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
    end

    def execute
      p "Gem will execute command: #{self.command}"
      TestRail::Command.execute_command("#{self.command}")
    end

    def self.execute_command(command)
      exec("#{command}")
    end
  end
end