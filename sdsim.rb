#!/usr/bin/env ruby

require "optparse"
require "./command"

# CLI

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: sdsim COMMAND [ARGS]"
  opt.separator ""
  opt.separator "The sdsim commands are:"

  # opt.on("-v", "--[no-]verbose", "Run verbosely") do |v|
  #   options[:verbose] = v
  # end

  opt.on("-g", "--generate", "Generate a new kWh data sample") do |g|
    options[:generate] = g
  end

  opt.on("-h", "--help", "help") do
    puts opt_parser
  end
end

# Handle ^C signal (Interrupt)
trap("INT") { exit }

opt_parser.parse!

if options.empty?
  puts opt_parser
elsif options[:generate]
  Command::Generate.new("sensor.samples").run
end