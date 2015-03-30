require 'rspec'
require_relative '../lib/test_rail_integration/cli'

describe CLI do

  before(:all) do
    @subject = CLI.new
  end

  context 'when executing perform cli command' do

    before(:all) do
      @subject.perform
    end

    it 'run_test_run.rb should be copied' do
      expect(File.exist?('run_test_run.rb')).to eq(true)
    end

    it 'copied run_test_run.rb should be identical' do
      expect(File.read('run_test_run.rb')).to eq(File.read('lib/test_rail_integration/generator/project/run_test_run.rb'))
    end

    it 'test_rail_data.yml should be copied' do
      expect(File.exist?('config/data/test_rail_data.yml')).to eq(true)
    end

    it 'copied test_rail_data.yml should be identical' do
      expect(File.exist?('run_test_run.rb')).to eq(true)
      expect(File.read('run_test_run.rb')).to eq(File.read('lib/test_rail_integration/generator/project/run_test_run.rb'))
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

  context 'when executing create_test_run command' do

    context 'and not passing test_run_name parameter' do

      it 'should see output message' do
        result = capture(:stdout) { @subject.create_test_run }
        expect(result).to eq("You must set correct test run name through --test_run_name\n")
      end

      it 'should not not call check_test_run_statuses method' do
        expect(TestRail::Connection).not_to receive(:create_test_run_with_name)
        @subject.create_test_run
      end

    end

    context 'and passing test_run_name parameter' do

      before(:all) do
        @subject.options = {:test_run_name => 'test run name'}
      end

      before(:each) do
        allow(TestRail::Connection).to receive(:create_test_run_with_name).and_return(
                                           "{\"id\":561,\"suite_id\":63,\"name\":\"Test run 26\\/03\\/2015\"}")
      end

      it 'should execute command once' do
        expect(TestRail::Connection).to receive(:create_test_run_with_name)
        @subject.create_test_run
      end

      it 'should see created test run id in output' do
        result = capture(:stdout) { @subject.create_test_run }
        expect(result).to eq("You successfully created test run with id 561\n")
      end

    end

    context 'and passing empty test_run_name parameter' do

      before(:all) do
        @subject.options = {:test_run_name => ''}
      end

      it 'should not execute command once' do
        expect(TestRail::Connection).not_to receive(:create_test_run_with_name)
        @subject.create_test_run
      end

      it 'should see a output' do
        result = capture(:stdout) { @subject.create_test_run }
        expect(result).to eq("Test_run_name parameter should not be empty\n")
      end
    end

  end

end