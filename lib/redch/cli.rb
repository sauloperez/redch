require 'redch'
require 'redch/helpers'
require 'redch/sos'
require 'redch/setup'
require 'redch/simulate'
require 'thor'
require 'macaddr'
require 'random-location'
require 'logger'

class Redch::CLI < Thor
  include Thor::Actions
  include Redch::Helpers

  attr_accessor :logger

  def initialize(*args)
    super
    install_traps

    @logger = Logger.new($stdout).tap do |log|
      log.progname = 'redch'
    end
  end

  desc "setup", "Sets up the environment to enable the use of the device"
  option :coordinates, :aliases => :c
  def setup
    location =  if options[:coordinates]
                  options[:coordinates].gsub(/\s+/, "").split(",")
                else
                  RandomLocation.near_by(41.65038, 1.13897, 90_000)
                end

    @setup = Redch::Setup.new
    @setup.location = location

    # It's the only way to not mess up the yaml
    # and avoid a Psych::BadAlias exception
    @setup.device_id = Mac.addr.dup

    if @setup.done?
      logger.info "Device #{@setup.device_id} already registered"
    else
      logger.info "Registering device #{@setup.device_id}..."
    end

    @setup.run
  end

  desc "simulate", "Simulate a sensor generating electrical power samples in W"
  option :period, :aliases => :p
  def simulate
    # TODO load location from config and pass it as option to setup method
    setup
    config = Redch::Config.load
    simulate = Redch::Simulate.new(config.sos.device_id, config.sos.location)
    simulate.period = options[:period].to_i if options[:period]

    logger.info "Sending an observation from #{put_coords(@setup.location)} every #{simulate.period} seconds...\n\n"
    simulate.run do |value|
      logger.info "sensor=#{@setup.device_id} location=#{@setup.location} value=#{value} unit=W"
    end
  end

  # Methods not available as commands
  no_commands do
    # Handle the shut down gracefully.
    # Save state or whatever needed
    def shut_down
      puts "\nBye"
    end

    def install_traps
      [:INT, :TERM].each do |signal|
        trap signal do
          shut_down
          exit 1
        end
      end
    end
  end
end
