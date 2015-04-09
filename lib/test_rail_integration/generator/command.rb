module TestRail

  class Command

    attr_accessor :command,
                  :tags,
                  :venture,
                  :env,
                  :type,
                  :id

    def initialize(id_of_run)
      self.id = id_of_run
    end
    
    def execute
      p "Gem will execute command: #{self.command}"
      TestRail::Command.execute_command("#{self.command}")
    end
    
    def generate
      #TODO do smth with weird replacement
      if venture.nil? || env.nil?
        self.command = self.command + " " + get_tags
      else
        self.command = self.command.gsub("\#{parameters.venture}", self.venture).gsub("\#{parameters.environment}", self.env) + " " + get_tags
      end
    end

    def get_tags
      cases = nil
      if type.nil?
        cases = Connection.cases_ids_by_default(self.id)
      else
        cases = Connection.cases_ids_by_type(self.id, self.type)
      end
      cases.map { |id| "@C"+id.to_s }.join(",")
    end

    def self.execute_command(command)
      exec("#{command}")
    end
  end
end