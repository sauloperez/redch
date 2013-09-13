#!/usr/bin/env ruby

require "rubygems"
require "amqp"

class Producer
  def initialize(channel, exchange)
    @channel  = channel
    @exchange = exchange
  end

  def publish(message, options = {})
    @exchange.publish(message, options)

    # Log the published data
    puts message
  end

  def handle_channel_exception(channel, channel_close)
    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
  end
end