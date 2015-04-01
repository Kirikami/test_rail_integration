module TestRail

  class TestRun

    attr_accessor :id, :name

    private
    def initialize(result)
      self.id = result["id"]
      self.name = result["name"]
    end

    def self.create(test_run_name)
      command_result = TestRail::Connection.create_test_run_with_name(test_run_name)
      TestRun.new(command_result)
    end

    def self.get_by_id(test_run_id)
      command_result = Connection.test_run_data(test_run_id)
      TestRun.new(command_result)
    end
  end
end