module TestRail

  class TestRun

    attr_accessor :id

    private
    def initialize(json)
      self.id = json["id"]
    end

    def self.create(test_run_name)
      command_result = TestRail::Connection.create_test_run_with_name(test_run_name)
      TestRun.new(JSON.parse(command_result))
    end
  end
end