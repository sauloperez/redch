#!/usr/bin/env ruby

require 'optparse'

module Command

	# Sensor data generation
	# values taken from: http://www.recgroup.com/en/aboutsolar/basic-solar-maths/
	# All power values are in kWh
	class Generate
		attr_accessor :mean, :dev, :gap_time, :keep_running

		@mean = 0.1 # Considering a high irradiation area
		@dev = 0.1 # 10% of standard deviation
		@gap_time = 1 # time between samples
		@keep_running = true # wether the data generating must continue

		public 

		def self.run
			puts "Generating sensor data..."
			while @keep_running
				puts "#{'%.3f' % generate_value} kWh"

				# output a sample per hour by default
				sleep @gap_time 
			end
		end

		protected

		def self.generate_value
			value = @mean
			lowest = @mean - @mean*@dev
			highest = @mean + @mean*@dev
			var = Random.new.rand(lowest..highest)

			if [true, false].sample
				value += var
			else
				# Don't allow negative values
				value = [value - var, 0].max 
			end
		end

	end
end


# CLI

options = {}

opt_parser = OptionParser.new do |opt|
	opt.banner = "Usage: sdsim COMMAND [ARGS]"
	opt.separator ""
	opt.separator "The sdsim commands are:"

	opt.on("-v", "--[no-]verbose", "Run verbosely") do |v|
		options[:verbose] = v
	end

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
	Command::Generate.run
end