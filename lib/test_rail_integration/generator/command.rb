module TestRail

  class Command

    attr_accessor :command,
                  :tags,
                  :venture,
                  :env

    def initialize(id_of_run)
      self.tags = get_tags(id_of_run)
    end
    
    def execute
      p "Gem will execute command: #{self.command}"
      TestRail::Command.execute_command("#{self.command}")
    end
    
    def generate
      #TODO do smth with weird replacement
      if venture.nil? || env.nil?
        self.command = self.command + " " + self.tags
      else
        self.command = self.command.gsub("\#{parameters.venture}", self.venture).gsub("\#{parameters.environment}", self.env) + " " + self.tags
      end
    end

    def get_tags(id_of_run)
      Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
    end

    def self.execute_command(command)
      exec("#{command}")
    end
  end
end