#!/usr/bin/env ruby
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#                    Version 2, December 2004 
# 
# Copyright (C) 2012 Aldrin Martoq
# 
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
# 
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
# 
#  0. You just DO WHAT THE FUCK YOU WANT TO.

require 'logger'
require 'rubygems'
require 'twitter'
require 'tweetstream'
require 'json'

TweetStream.configure do |config| 
  config.consumer_key = 'AAA'
  config.consumer_secret = 'BBB'
  config.oauth_token = 'CCC'
  config.oauth_token_secret = 'DDD'
  config.auth_method = :oauth
end

Twitter.configure do |config|
  config.consumer_key = 'AAA'
  config.consumer_secret = 'BBB'
  config.oauth_token = 'CCC'
  config.oauth_token_secret = 'DDD'
end

client = Twitter::Client.new
log = Logger.new('roy.log')
log.level = Logger::INFO

while true do
  log.info "STARTING"
  begin
    s = TweetStream::Client.new.on_error do |message|
      log.info "ERROR: #{message}"
    end.on_reconnect do |timeout, retries|
      log.info "RECONNECT: #{timeout} #{retries}"
    end.track('kernel panic', 'computador ctm') do |status|
      log.info "[#{status.user.screen_name}] #{status.text}"
      message = "@#{status.user.screen_name} Have you tried turning it off and on again?"
      client.update(message, :in_reply_to_status_id => status.id)
      log.info "  => #{message}"
    end
  rescue Interrupt => e
    log.error "Interrupted"
    abort
  rescue Exception => e
    log.error e.message
    log.error e.backtrace
  end
end
