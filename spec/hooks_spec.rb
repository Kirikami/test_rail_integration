require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/test_rail_hooks'

describe 'Update test results' do

  before(:each) do
    allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
    @scenario = double('scenario')
    allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
    allow(@scenario).to receive(:title).and_return('title')
    allow(TestRail::Connection).to receive(:change_test_run_name).and_return('changed!')
  end

  context 'test that test rail data is correct if there is no previous result' do

    before(:each) do
      allow(TestRail::Connection).to receive(:get_test_result).and_return([])
    end

    it 'current result should be passed' do
      allow(@scenario).to receive(:passed?).and_return(true)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
    end

    it 'current result should be failed' do
      allow(@scenario).to receive(:passed?).and_return(false)
      steps = double('steps')
      allow(steps).to receive(:exception).and_return('exception')
      allow(@scenario).to receive(:steps).and_return(steps)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n "})
    end

  end

  context 'test that test rail data is correct if previous result is passed' do

    before(:each) do
      allow(TestRail::Connection).to receive(:get_test_result).and_return(
                                         [{"status_id" => 1, "comment" =>"test **passed:**"}])
    end

    it 'current result should be passed' do
      allow(@scenario).to receive(:passed?).and_return(true)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
    end

    it 'current result should be failed' do
      allow(@scenario).to receive(:passed?).and_return(false)
      steps = double('steps')
      allow(steps).to receive(:exception).and_return('exception')
      allow(@scenario).to receive(:steps).and_return(steps)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n "})
    end

  end

  context 'test that test rail data is correct if previous result is failed' do

    before(:each) do
      allow(TestRail::Connection).to receive(:get_test_result).and_return(
                                         [{"status_id" => 5, "comment" =>"test **failed:**"}])
    end

    it 'current result should be failed' do
      allow(@scenario).to receive(:passed?).and_return(false)
      steps = double('steps')
      allow(steps).to receive(:exception).and_return('exception')
      allow(@scenario).to receive(:steps).and_return(steps)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n test **failed:**"})
    end

    it 'current result should be comment' do
      allow(@scenario).to receive(:passed?).and_return(true)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>0, :comment => 'test **passed:**'})
      expect(test_result.to_test_rail_api).to eq({:comment => "test **passed:** \"title\"\n test **failed:**"})
    end

  end

  context 'test that test rail data is correct if previous result is comment' do

    before(:each) do
      allow(TestRail::Connection).to receive(:get_test_result).and_return(
                                         [{"status_id" => 5, "comment" =>"test **failed:**"}])
    end

    it 'current result should be comment' do
      allow(@scenario).to receive(:passed?).and_return(true)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>0, :comment => 'test **passed:**'})
      expect(test_result.to_test_rail_api).to eq({:comment => "test **passed:** \"title\"\n test **failed:**"})
    end

    it 'current result should be failed' do
      allow(@scenario).to receive(:passed?).and_return(false)
      steps = double('steps')
      allow(steps).to receive(:exception).and_return('exception')
      allow(@scenario).to receive(:steps).and_return(steps)
      test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.title).to eq('title')
      expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n test **failed:**"})
    end

  end

end