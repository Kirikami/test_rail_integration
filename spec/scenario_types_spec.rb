require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/test_rail_hooks'

describe 'Scenario types' do

  context 'when scenario outline received' do
    before :each do
      allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
      @scenario = double('scenario')
      @scenario_outline = double('scenario')
      allow(@scenario_outline).to receive(:title).and_return('title scenario outline')
      allow(@scenario).to receive(:scenario_outline).and_return(@scenario_outline)
      allow(@scenario).to receive(:kind_of?).and_return(true)
      allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
      allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    end
    context "with pass result" do
      before do
        allow(@scenario).to receive(:passed?).and_return(true)
        allow(@scenario).to receive(:scenario_exception).and_return(nil)
      end
      it "should receive outline title" do
        test_result = TestRail::Hook.update_test_rail(@scenario)
        expect(test_result.test_case_id).to eq('4556')
        expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
        expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title scenario outline\""})

      end

    end

    context "with fail result" do
      before do
        allow(@scenario).to receive(:scenario_exception).and_return('scenario outline exception')
        allow(@scenario).to receive(:passed?).and_return(false)
      end
      it "should receive outline title and execption" do
        test_result = TestRail::Hook.update_test_rail(@scenario)
      expect(test_result.test_case_id).to eq('4556')
      expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
      expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title scenario outline\"\n Exception : scenario outline exception\n "})
    end
    end

  end

  context "when standart scenario received" do
    before :each do
      allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
      @scenario = double('scenario')
      @steps = double('scenario')
      allow(@scenario).to receive(:kind_of?).and_return(false)
      allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
      allow(@scenario).to receive(:title).and_return('title')
      allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    end
    context "with passed result" do
      before do
        allow(@steps).to receive(:exception).and_return(nil)
        allow(@scenario).to receive(:steps).and_return(@steps)
        allow(@scenario).to receive(:passed?).and_return(true)
      end
      it "should keep title from scenrio" do
        test_result = TestRail::Hook.update_test_rail(@scenario)
        expect(test_result.test_case_id).to eq('4556')
        expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
        expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
      end
    end
    context "with failed result" do
      before do
        allow(@steps).to receive(:exception).and_return('exception')
        allow(@scenario).to receive(:steps).and_return(@steps)
        allow(@scenario).to receive(:passed?).and_return(false)
      end
      it "should receive scenario title and exception" do
        test_result = TestRail::Hook.update_test_rail(@scenario)
        expect(test_result.test_case_id).to eq('4556')
        expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
        expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n "})
      end
    end
  end
end