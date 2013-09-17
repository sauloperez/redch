#!/usr/bin/env ruby

require "rubygems"
require "json"
require "amqp"

class Producer
  def initialize(channel, exchange)
    @channel  = channel
    @exchange = exchange
  end

  def publish(message, options = {})
    # Publish the JSON encoded message to the exchange
    @exchange.publish(message.to_json, options)

    # Log the published data
    puts message
  end

  def handle_channel_exception(channel, channel_close)
    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
  end
end