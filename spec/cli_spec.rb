require 'rspec'
require_relative '../lib/test_rail_integration/cli'
require_relative '../lib/test_rail_integration/generator/connection'


describe CLI do

  before(:all) do
    @subject = CLI.new
  end

  context 'when executing perform cli command' do

    before(:all) do
      @subject.perform
    end

    it 'test_rail_data.yml should be copied' do
      expect(File.exist?('config/data/test_rail_data.yml')).to eq(true)
    end

    it 'copied test_rail_data.yml should be identical' do
      expect(File.exist?('config/data/test_rail_data.yml')).to eq(true)
      expect(File.read('config/data/test_rail_data.yml')).to eq(File.read('lib/test_rail_integration/generator/project/test_rail_data.yml'))
    end

  end

  context 'when executing check_test_run_and_update cli command ' do

    context 'and not passing test_run_id param' do

      it 'should see output message' do
        result = capture(:stdout) { @subject.check_test_run_and_update }
        expect(result).to eq("You must set correct test run id through --test_run_id\n")
      end

      it 'should not not call check_test_run_statuses method' do
        expect(TestRail::Check).not_to receive(:check_test_run_statuses)
        @subject.check_test_run_and_update
      end

    end

    context 'and passing test run id parameter ' do

      before(:all) do
        @subject.options = {:test_run_id => 12345}
      end

      it 'should execute command once' do
        expect(TestRail::Check).to receive(:check_test_run_statuses)
        @subject.check_test_run_and_update
      end

      it 'should not see any output ' do
        allow(TestRail::Check).to receive(:check_test_run_statuses).and_return([])
        result = capture(:stdout) { @subject.check_test_run_and_update }
        expect(result).to eq('')
      end

    end

  end

  describe 'when executing shoot cli command' do

    before(:each) do
      allow(TestRail::Connection).to receive(:test_run_name).and_return("AT id staging new")
      allow(TestRail::Connection).to receive(:cases_id).and_return(["11", "22", "33"])
      @subject.options = {test_run_id: 777}
    end

    it 'should call execution command' do
      expect(TestRail::TestRailTools).to receive(:exec)
      @subject.shoot
    end
  end
end







