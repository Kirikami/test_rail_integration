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

end