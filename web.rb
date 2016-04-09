require 'sinatra'
require 'json'
require 'httpclient'

line_headers = {
  'Content-Type' => 'application/json; charset=UTF-8',
  'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
  'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
  'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"]
}
line_url = 'https://trialbot-api.line.me/v1/events'
channel = 1383378250
type = '138311609000106303'

get '/' do
  'OK'
end

post '/callback' do
  res = request.body.read
  params = JSON.parse(res)
  results = params['result']
  result = results[0]
  to = result['from']
  h = HTTPClient.new
  line_content = {
    to: [to],
    toChannel: channel,
    eventType: type,
    content: {
      contentType: 1,
      toType: 1,
      text: 'どんどん'
    }
  }

  pres = h.post_content(line_url, body: line_content.to_json, header: line_headers)
  puts pres.body.read
end
