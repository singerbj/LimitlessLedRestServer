#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'limitless_led'

puts "Starting server..."

configure do 
  set :bridge, LimitlessLed::Bridge.new(host: "192.168.2.5", port: 8899)

  def execute(command, param, group_id)
    puts command
    puts param
    if group_id
      group = settings.bridge.group(group_id)
      3.times do  
        if param
          group.method(command).call param
        else
          group.method(command).call
        end
      end
    else
      3.times do
        if param
          settings.bridge.method(command).call param
        else
          settings.bridge.method(command).call
        end
      end
    end
  end

  def process(request_body)
    begin
      r = "{}"
      id = nil
      if request_body["id"] # 1..4
        id = request_body["id"].to_i
      end
      if request_body["status"] # 'all_on', 'all_off', 'white', 'on', 'off'
        execute(request_body["status"], nil, id)
      end
      if request_body["color"]  # 'Red' or 178
        execute('color', request_body["color"], id)
      end
      if request_body["disco"]  # 'disco', 'disco_faster', 'disco_slower'
        execute(request_body["disco"], nil, id)
      end
      if request_body["brightness"]  # 0-100 (translate to 2-27)
        temp = request_body["brightness"].to_i
        brightness = (temp * 0.25).round + 2
        execute('brightness', brightness, id)
      end
    rescue
      r = '{ error: "true"}'
    end
    r
  end
end



#Set all tracked LEDs
post '/all' do
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

  r = process(request_body)
  puts r
end 

# Alarms ################################
get '/alarm/:alarm_id' do |alarm_id|

end

post '/alarm/:alarm_id' do |alarm_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

put '/alarm/:alarm_id' do |alarm_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

delete '/alarm/:alarm_id' do |alarm_id|

end

