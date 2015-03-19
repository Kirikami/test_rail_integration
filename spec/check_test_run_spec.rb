require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/project/check'

describe 'Checking test run' do

  context 'when last result is pass but we already have fail results' do

    it 'should change status to fail' do

      allow(TestRail::Connection).to receive(:cases_with_types).and_return([1011])
      allow(TestRail::Connection).to receive(:get_test_result).and_return([{"status_id" => 1, :comment => "FTW"}, {"status_id" => 5, :comment => "Burn heretics"}])
      allow(TestRail::Connection).to receive(:get_case_info).and_return({id: 1011, "title" => 'MLP'})
      allow(TestRail::Connection).to receive(:commit_test_result).and_return([])

      test_case_results = TestRail::Check.check_test_run_statuses
      expect(test_case_results[0].title).to eq('MLP')
      expect(test_case_results[0].comment).to eq({:status => 5, :comment => "test **failed:**"})
    end

    it "should call api twice" do

      allow(TestRail::Connection).to receive(:cases_with_types).and_return([1011, 1213])
      allow(TestRail::Connection).to receive(:get_test_result).and_return([{"status_id" => 1, :comment => "FTW"}, {"status_id" => 5, :comment => "Burn heretics"}] )
      allow(TestRail::Connection).to receive(:get_case_info).and_return({id: 1011, "title" => 'MLP'})
      allow(TestRail::Connection).to receive(:commit_test_result).and_return([])

      test_case_results = TestRail::Check.check_test_run_statuses
      expect(test_case_results.length).to eq 2
    end
  end
end