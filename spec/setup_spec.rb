require 'spec_helper'

# The tests must be run in the following order
# otherwise the database might contain references to the device
# while the config file has been deleted (= inconsistent state)

describe Redch::Setup do
  let(:location) { [41.82749, 1.60584] }
  let(:id) { Time.now.getutc.to_i.to_s }
  let(:sos_client) { double 'sos_client' }

  before :all do
    delete_config_file
  end

  after :all do
    delete_config_file
  end

  before :each do
    @setup = Redch::Setup.new    
  end

  describe '#run', :run => true do

    context 'when the setup has not been executed yet' do
      it 'registers and stores the passed device id' do
        delete_config_file

        sos_client
          .should_receive(:register_device)
          .with(id)
          .and_return(id)

        @setup.sos_client= sos_client

        @setup.location= location
        @setup.device_id= id
        @setup.run 
        expect(@setup.device_id).to_not be_empty
      end

      it 'stores the passed coordinates as its location' do
        delete_config_file

        sos_client
          .should_receive(:register_device)
          .with(id)
          .and_return(id)

        @setup.sos_client= sos_client

        @setup.location= location
        @setup.device_id= id
        @setup.run
        expect(@setup.location).to eq(location)
      end

      it 'raises if any of location or device_id are not set' do
        delete_config_file

        sos_client.should_not_receive(:register_device)

        # Only the device_id is passed
        expect { 
          setup = Redch::Setup.new
          setup.sos_client= sos_client
          setup.device_id= id
          setup.run
        }.to raise_error(StandardError)

        # Only the location is passed
        expect { 
          setup = Redch::Setup.new
          setup.sos_client= sos_client
          setup.location= location
          setup.run
        }.to raise_error(StandardError)

        # Neither of them is passed
        expect { 
          setup = Redch::Setup.new
          setup.sos_client= sos_client
          setup.run
        }.to raise_error(StandardError)
      end
    end

    context 'when the setup has already been executed' do
      it "it doesn't call the service and keeps the device id" do
        sos_client
          .should_receive(:register_device)
          .with(id)
          .and_return(id)
          
        @setup.sos_client= sos_client

        @setup.device_id= id
        @setup.location= location
        @setup.run

        sos_client.should_not_receive(:register_device)
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
        delete_config_file

        expect(@setup.done?).to eq(false)
      end
    end

    context "when the setup has already been executed" do
      it "returns true" do
        sos_client
          .should_receive(:register_device)
          .with(id)
          .and_return(id)

        @setup.sos_client= sos_client

        @setup.device_id= id
        @setup.location= location
        @setup.run

        sos_client.should_not_receive(:register_device)
        @setup.run

        expect(@setup.done?).to eq(true)
      end
    end
  end
end