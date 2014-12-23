#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'limitless_led'

puts "Starting server..."

configure do 
  
  set :bridges, []
  [100..255].each do |i|
    settings.bridges.push(LimitlessLed::Bridge.new(host: "192.168.1.#{i}", port: 8899))
  end

  def execute(command, param, group_id) 
    Thread.new do
      settings.bridges.each do |bridge|
        begin
          if group_id
            group = bridge.group(group_id)
            group.method(command).call param
          else
            bridge.method(command).call param
          end
        rescue
          puts "Error running command #{command} with param #{param}"
        end
      end
    end
  end
 
end

#Set all tracked LEDs
post '/all' do
  request.body.rewind
  request_body = JSON.parse(request.body.read) 
  
  settings.bridges.each do |b|
    if request_body.status # 'all_on', 'all_off'
      execute(request_body.status)
    end
    if request_body.color  # 'Red' or 178
      execute('color', request_body.color)
    end
    if request_body.disco  # 'disco', 'disco_faster', 'disco_slower'
      execute(request_body.disco)
    end
    if request_body.brightness  # 0-100 (translate to 2-27)
      temp = request_body.brightness
      brightness = (temp * 25).round + 2
      execute('brightness', brightness)
    end
    if request_body.reset  # true,false
      if request_body.reset == true
        execute('white')  
      end
    end
  end
end

# Bridges ###############################
get '/bridge/:bridge_id' do |bridge_id|

end

post '/bridge/:bridge_id' do |bridge_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

put '/bridge/:bridge_id' do |bridge_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

delete '/bridge/:bridge_id' do |bridge_id|

end

# Groups ################################
get '/group/:group_id' do |group_id|

end

post '/group/:group_id' do |group_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

put '/group/:group_id' do |group_id|
  request.body.rewind
  request_body = JSON.parse(request.body.read) 

end

delete '/group/:group_id' do |group_id|

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

