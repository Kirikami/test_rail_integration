require_relative 'test_rail_data_load'

module TestRail
  class TestCaseResult

    attr_accessor :test_case_id,
                  :comment,
                  :exception_message,
                  :assign_to,
                  :previous_comment,
                  :scenario,
                  :test_results

    COMMENT_STATUS ||= TestRail::TestRailDataLoad.test_rail_data[:status_comment]
    PASS ||= TestRail::TestRailDataLoad.test_rail_data[:test_pass]
    FAILED ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed]
    NEW ||= TestRail::TestRailDataLoad.test_rail_data[:new_test]
    PASS_COMMENT ||= TestRail::TestRailDataLoad.test_rail_data[:test_passed_comment]
    FAILED_COMMENT ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed_comment]
    ASSIGN_TO ||= TestRail::TestRailDataLoad.test_rail_data[:assign_to]

    COMMENT ||= {:pass => {status: PASS, comment: PASS_COMMENT},
                 :fail => {status: FAILED, comment: FAILED_COMMENT},
                 :unchanged_pass => {status: COMMENT_STATUS, comment: PASS_COMMENT}
    }

    TEST_RAIL_ID_REGEX ||= /^@C\d+/

    def initialize(scenario)
      self.test_case_id = scenario.source_tag_names.find { |e| e.match(TEST_RAIL_ID_REGEX) }[2..-1]
      self.scenario = scenario
      self.test_results = TestRail::Connection.get_test_results(self.test_case_id)
      self.previous_comment = get_last_failed_comment unless get_indexes_of_fails.empty?
    end

    def failed?
      !scenario.passed?
    end

    def passed?
      scenario.passed? && get_previous_test_result != FAILED
    end

    def unchanged_pass?
      scenario.passed? && get_previous_test_result == FAILED
    end

    #
    # Get indexes of failed results
    #
    def get_indexes_of_fails
      indexes = self.test_results.map.with_index { |result, index| result["status_id"] == TestCaseResult::COMMENT[:fail][:status] ? index : nil }
      indexes.compact
    end

    def get_indexes_of_passes
      indexes = self.test_results.map.with_index { |result, index| result["status_id"] == TestCaseResult::COMMENT[:pass][:status] ? index : nil }
      indexes.compact
    end

    #
    # Parse results and returns previous comment.
    #
    def get_previous_comments
      test_comment = self.test_results.map { |hash| hash["comment"] }
      comment = test_comment
      comment ||= []
      comment
    end

    #
    # Get last failed comment for test case
    #
    def get_last_failed_comment
      comments = get_previous_comments
      index = get_indexes_of_fails.first
      comments[index]
    end

    #
    # Parse results and returns Failed if this test was marked as failed.
    #
    def get_previous_test_result
      test_results = self.test_results.map { |status_hash| status_hash["status_id"] }
      status = FAILED if test_results.include?(FAILED)
      status ||= PASS if test_results.first == PASS
      status ||= NEW
      status
    end

    def update
      self.comment = COMMENT[:pass] if passed?
      self.comment ||= COMMENT[:unchanged_pass] if unchanged_pass?

      if failed?
        self.comment ||= COMMENT[:fail]
        self.exception_message = scenario.steps.exception rescue nil
        self.assign_to = ASSIGN_TO
      end

      raise("Invalid test case result : scenario.passed? #{self.scenario.passed?}, prev_result? #{get_previous_test_result}, run_result? #{self.scenario.passed?}") if self.comment.nil?

      TestRail::Connection.commit_test_result(self)

      self
    end

    #
    # Send status to TestRail
    #
    # {status_id: 1, comment: "Test passed"}
    #
    def to_test_rail_api
      comment_message = "#{self.comment[:comment]} \"#{self.scenario.title}\""
      comment_message = "**[#{Fixtures.instance['venture']}]** #{self.comment[:comment]} for \"#{self.title}\"" unless defined?(Fixtures.instance['venture']).nil?
      comment_message += "\n Exception : #{self.exception_message}" unless self.exception_message.nil?
      comment_message += "\n #{self.previous_comment}" if self.comment[:status] == COMMENT[:fail][:status] || self.comment[:status] == COMMENT[:unchanged_pass][:status]
      if self.comment[:status] == COMMENT_STATUS
        {comment: comment_message}
      else
        {status_id: self.comment[:status], comment: comment_message}
      end
    end

  end
end