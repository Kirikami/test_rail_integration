module TestRail

  class TestRun

    attr_accessor :id

    private
    def initialize(result)
      self.id = result["id"]
    end

    def self.create(test_run_name)
      command_result = TestRail::Connection.create_test_run_with_name(test_run_name)
      TestRun.new(command_result)
    end
  end
end