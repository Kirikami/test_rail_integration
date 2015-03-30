require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/test_rail_tools'
require_relative '../lib/test_rail_integration/generator/test_rail_data_load'

describe 'Test Rail tools' do

  describe 'run cucumber command method' do
    before do
      allow(TestRail::TestRailDataLoad).to receive(:test_rail_data).and_return({exec_command: "Command "})
      allow(TestRail::Connection).to receive(:cases_id).and_return([1011, 1111])
      @result = capture(:stdout) { TestRail::TestRailTools.run_cucumber_command(121) }
    end

    it 'should generate command' do
      expect(@result).to include 'Command @C1011,@C1111'
    end
end

  describe 'write test run id' do
    before do
      TestRail::TestRailTools.write_test_run_id(123)
    end

    it 'should write test run id into file' do
      expect(File.read('config/data/test_rail_data.yml')).to include ":test_run_id: 123"
    end

  end

  describe 'write executable command' do
    before do
      TestRail::TestRailTools.write_executable_command("Command")
    end

    it 'should change executable command' do
      expect(File.read('config/data/test_rail_data.yml')).to include ":exec_command: Command "
    end
  end

  describe 'prepare config' do
    before do
      allow(TestRail::TestRailDataLoad).to receive(:test_rail_data).and_return({exec_command: "Command "})
      allow(TestRail::Connection).to receive(:cases_id).and_return([1011, 1111])
      @result = capture(:stdout) {TestRail::TestRailTools.prepare_config(125)}
    end

    it 'should setup test run id' do
      expect(TestRail::Connection.test_run_id).to eq(125)
    end

    it 'should write test run id into file' do
      expect(File.read('config/data/test_rail_data.yml')).to include ":test_run_id: 125"
    end

    it 'should run cucumber executable command' do
      expect(@result).to include 'Command @C1011,@C1111'
    end

  end
end