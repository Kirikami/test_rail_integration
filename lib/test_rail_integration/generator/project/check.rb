require_relative '../../generator/test_rail_data_load'
require_relative '../../generator/API_client'
require_relative '../../generator/connection'
require_relative '../../generator/test_rail_tools'

module TestRail

  class Check

    def self.check_test_run_statuses
      start_time = Time.new
      results = []

      test_cases_ids = Connection.cases_with_types
      test_cases_ids.each do |test_case_id|

        case_info = Connection.get_case_info(test_case_id)
        scenario = Scenario.new(case_info['title'], ["@C#{test_case_id}"])
        test_case_result = TestRail::TestCaseResult.new(scenario)
        test_results = test_case_result.test_results.map { |status_hash| status_hash["status_id"] }

        if test_results.include?(TestCaseResult::COMMENT[:fail][:status]) &&
            test_results.include?(TestCaseResult::COMMENT[:pass][:status])

          if test_case_result.get_indexes_of_passes.first < test_case_result.get_indexes_of_fails.first
            test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:fail]
            TestRail::Connection.commit_test_result(test_case_result)

            p test_case_result.test_case_id
            p test_case_result.scenario.title
            results.push(test_case_result)
          end

        end
      end
      end_time = Time.now - start_time
      p "Time for run  = #{end_time} seconds"
      results
    end

  end

  class Scenario

    attr_accessor :title, :source_tag_names

    def initialize(title, source_tag_names)
      self.title = title
      self.source_tag_names = source_tag_names
    end

  end

end