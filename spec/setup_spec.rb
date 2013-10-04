require 'spec_helper'

# The tests must be run in the following order
# otherwise the database might contain references to the device
# while the config file has been deleted (= inconsistent state)

describe Redch::Setup do
  before :all do
    filename = Redch::Config.filename
    File.delete(filename) if File.exist?(filename)
  end

  before :each do
    @setup = Redch::Setup.new    
  end

  describe '#run', :run => true do

    context 'when the setup has not been executed yet' do
      it 'stores the registered device id' do
        @setup.run 
        expect(@setup.device_id).to_not be_empty
      end
    end

    context 'when the setup has already been executed' do
      it "it doesn't call the service and keeps the device id" do
        id = @setup.device_id
        @setup.run
        expect(@setup.device_id).to eq(id)
      end
    end    
  end

  # It must be executed alone after previously reseting the DB with test data
  # in order to avoid the inconsistent state produced by the #run test
  describe '#done?', :done? => true do

    context "when the setup has not been executed yet" do
      it "returns false" do
        filename = Redch::Config.filename
        File.delete(filename) if File.exist?(filename)
        expect(@setup.done?).to eq(false)
      end
    end

    context "when the setup has already been executed" do
      it "returns true" do
        @setup.run
        expect(@setup.done?).to eq(true)
      end
    end
  end
end