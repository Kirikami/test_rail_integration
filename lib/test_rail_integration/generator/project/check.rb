require_relative '../../generator/test_rail_data_load'
require_relative '../../generator/API_client'
require_relative '../../generator/connection'
require_relative '../../generator/test_rail_tools'

module TestRail

  class Check


    def self.check_test_run_statuses
      start_time = Time.new
      results = []

      test_cases_id = Connection.cases_with_types
      test_cases_id.each do |test_case|

        test_results = Connection.get_test_result(test_case).map { |status_hash| status_hash["status_id"] }
        if test_results.include?(TestCaseResult::COMMENT[:fail][:status]) && test_results.include?(TestCaseResult::COMMENT[:pass][:status])
          fail_indexes = test_results.map.with_index{ |element, index| element == TestCaseResult::COMMENT[:fail][:status] ? index : nil }.compact
          pass_indexes = test_results.map.with_index{ |element, index| element == TestCaseResult::COMMENT[:pass][:status] ? index : nil }.compact

          if pass_indexes.first < fail_indexes.first
            scenario = Connection.get_case_info(test_case)
            test_case_result = TestRail::TestCaseResult.new(test_case, scenario['title'])
            test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:fail]
            TestRail::Connection.commit_test_result(test_case_result)

            p test_case_result.test_case_id
            p test_case_result.title
            results.push(test_case_result)
          end
        end
      end
      end_time = Time.now - start_time
      p "Time for run  = #{end_time} seconds"
      results
    end

  end
end