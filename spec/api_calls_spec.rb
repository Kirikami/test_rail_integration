require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'

describe 'Api calls' do

  context 'When i am creating test case result' do

    before(:each) do
      allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
      @scenario = double('scenario')
      @steps = double('scenario')
      allow(@steps).to receive(:exception).and_return(nil)
      allow(@scenario).to receive(:steps).and_return(@steps)
      allow(@scenario).to receive(:kind_of?).and_return(false)
      allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
      allow(@scenario).to receive(:title).and_return('title')
      allow(@scenario).to receive(:passed?).and_return(true)
      allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    end

    it 'i am calling get_test_results api method once' do
      expect(TestRail::Connection).to receive(:get_test_results).once
      test_case_result = TestRail::TestCaseResult.new(@scenario)
      test_case_result.update
    end

    it 'i am calling commit_test_result api method once' do
      expect(TestRail::Connection).to receive(:commit_test_result).once
      test_case_result = TestRail::TestCaseResult.new(@scenario)
      test_case_result.update
    end

  end

end