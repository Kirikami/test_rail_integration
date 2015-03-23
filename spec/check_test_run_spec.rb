require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/project/check'

describe 'Checking test run' do

  context 'when last result is pass' do

    context 'but we already have one result' do

      before(:each) do
        allow(TestRail::Connection).to receive(:cases_with_types).and_return([1011])
        allow(TestRail::Connection).to receive(:get_test_results).and_return([{"status_id" => 1, :comment => "FTW"}, {"status_id" => 5, :comment => "Burn heretics"}])
        allow(TestRail::Connection).to receive(:get_case_info).and_return({id: 1011, "title" => 'MLP'})
        allow(TestRail::Connection).to receive(:commit_test_result).and_return([])
      end

      it 'should change status to fail' do
        test_case_results = TestRail::Check.check_test_run_statuses
        expect(test_case_results[0].comment).to eq({:status => 5, :comment => "test **failed:**"})
      end

      it 'should call api once' do
        expect(TestRail::Connection).to receive(:cases_with_types).once
        expect(TestRail::Connection).to receive(:get_case_info).once
        expect(TestRail::Connection).to receive(:get_test_results).once
        expect(TestRail::Connection).to receive(:commit_test_result).once
        TestRail::Check.check_test_run_statuses
      end

    end

    context 'but we already have several results' do

      before(:each) do
        allow(TestRail::Connection).to receive(:cases_with_types).and_return([1011, 1213])
        allow(TestRail::Connection).to receive(:get_test_results).and_return([{"status_id" => 1, :comment => "FTW"}, {"status_id" => 5, :comment => "Burn heretics"}] )
        allow(TestRail::Connection).to receive(:get_case_info).and_return({id: 1011, "title" => 'MLP'})
        allow(TestRail::Connection).to receive(:commit_test_result).and_return([])
      end

      it 'should have two results' do
        test_case_results = TestRail::Check.check_test_run_statuses
        expect(test_case_results.length).to eq 2
      end

      it 'should call api once' do
        expect(TestRail::Connection).to receive(:cases_with_types).once
        expect(TestRail::Connection).to receive(:get_case_info).twice
        expect(TestRail::Connection).to receive(:get_test_results).twice
        expect(TestRail::Connection).to receive(:commit_test_result).twice
        TestRail::Check.check_test_run_statuses
      end

    end

  end
end