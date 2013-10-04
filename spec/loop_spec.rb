require 'spec_helper'

describe Redch::Loop do
  before :each do
    @loop = Redch::Loop.new
  end

  describe '#new', :new => true do
    it "Redch::Loop instance" do
      expect(@loop).to be_an_instance_of Redch::Loop
    end

    it "takes and optional time interval" do
      l = Redch::Loop.new(2)
      expect(l).to be_an_instance_of Redch::Loop
    end
  end

  describe '#start', :start => true do
    let(:l) { Redch::Loop.new(1) }

    context "when the time interval is provided" do
      it "executes the block each interval" do
        i = 0
        n = 3
        l.start { 
          if i < n
            i += 1
          else
            EventMachine.stop
          end
        }

        expect(i).to eq(n)
      end
    end

    context "when the time interval is not provided" do
      it "executes the block indefinitely" do
        ran = nil
        @loop.start {
          ran = EventMachine::reactor_running?
          EventMachine.stop
        }

        expect(ran).to be(true)
        expect(EventMachine::reactor_running?).to be(false)
      end
    end
    
    it "raises and stops when the block raises" do
      expect { 
        @loop.start {
          raise StandardError.new
        }
      }.to raise_error(StandardError)
      expect(EventMachine::reactor_running?).to be(false)
    end
  end

  describe '#stop', :stop => true do
    it "calls the block and stops the execution of the loop" do
      i = 0
      n = 0
      @loop.start {
        i += 1
        @loop.stop { n = i }
      }

      expect(i).to eq(1)
      expect(n).to eq(i)
      expect(EventMachine::reactor_running?).to be(false)
      expect(n).to eq(i)
    end
  end
end