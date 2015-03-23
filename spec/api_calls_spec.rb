require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'

describe 'Api calls' do

  it 'When i am creating test case result i am calling get_test_results api method once' do
    allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
    @scenario = double('scenario')
    allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
    allow(@scenario).to receive(:title).and_return('title')
    allow(@scenario).to receive(:passed?).and_return(true)
    allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    expect(TestRail::Connection).to receive(:get_test_results).once
    test_case_result = TestRail::TestCaseResult.new(@scenario)
    test_case_result.update
  end

end