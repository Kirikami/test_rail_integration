require_relative '../../generator/test_rail_data_load'
require_relative '../../generator/API_client'
require_relative '../../generator/connection'
require_relative '../../generator/test_rail_tools'


module TestRail

  class CheckTestRun

    def check
      test_cases_id = Connection.cases_with_types
      test_cases_id.each do |test_case|

        test_results = Connection.get_test_result(test_case).map { |status_hash| status_hash["status_id"] }
        if test_results.include?(TestCaseResult::COMMENT[:fail][:status]) && test_results.include?(TestCaseResult::COMMENT[:pass][:status])
          fail_indexes = Connection.get_indexes_of_fails(test_case)
          pass_indexes = Connection.get_test_result(test_case).map.with_index { |result, index| result["status_id"] == TestCaseResult::COMMENT[:pass][:status] ? index : nil }
          pass_indexes.compact!

          if pass_indexes.first < fail_indexes.first
            scenario = Connection.get_case_info(test_case)
            test_case_result = TestRail::TestCaseResult.new(test_case, scenario['title'])
            test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:fail]
            TestRail::Connection.commit_test_result(test_case_result)

            return test_case_result
          end
        end
      end
    end

  end
end
