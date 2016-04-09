require 'sinatra'
require 'json'
require 'pp'
require 'rest-client'

line_headers = {
  'Content-Type' => 'application/json; charset=UTF-8',
  'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
  'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
  'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"]
}
line_url = 'https://trialbot-api.line.me/v1/events'

get '/' do
  'OK'
end

post '/callback' do
  res = request.body.read
  params = JSON.parse(res)
  results = params['result']
  result = results[0]
  to = result['content']['from']
  puts "message to #{to}"
  RestClient.proxy = ENV["FIXIE_URL"]
  line_content = {
    to: [to],
    toChannel: 1383378250,
    eventType: '138311608800106203',
    content: {
      contentType: 1,
      toType: 1,
      text: 'どんどん'
    }
  }

  response = nil
  begin
    response = RestClient.post(line_url, line_content.to_json, line_headers)
  rescue  RestClient::Forbidden => e
    pp e
  end

  if response
    puts response.to_str
  end

  'OK'
end
