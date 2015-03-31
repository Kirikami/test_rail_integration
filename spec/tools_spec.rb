require 'rspec'
require_relative '../lib/test_rail_integration/generator/connection'
require_relative '../lib/test_rail_integration/generator/test_rail_tools'
require_relative '../lib/test_rail_integration/generator/test_rail_data_load'

describe 'Test Rail tools' do

  describe 'run generate_executable_command method' do

    before(:each) do
      allow(TestRail::Connection).to receive(:cases_id).and_return([1011, 1111])
      @command = "cucumber -p lazada.vn.staging TESTRAIL=1 --color -f json -o cucumber.json -t @C1011,@C1111"
    end

    context 'with test run id and venture' do

      it 'should generate standard command' do
        result = TestRail::TestRailTools.generate_executable_command(121, ['vn', 'staging'])
        expect(result).to eq "cucumber -p lazada.vn.staging TESTRAIL=1 --color -f json -o cucumber.json -t @C1011,@C1111"
      end

    end

    context 'with test run id and new command' do

      it 'should generate command' do
        expect(TestRail::TestRailTools.generate_executable_command(121, nil, "Command")).to eq 'Command @C1011,@C1111'
      end

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

end