require 'sinatra'
require 'json'
require 'httpclient'

headers = {
  'Content-Type' => 'application/json; charset=UTF-8',
  'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
  'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
  'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"]
}
line_url = 'https://trialbot-api.line.me/v1/events'
channel = 1441301333
type = 138311609000106303

get '/' do
  'Hello, world'
  puts 'log log hello'
end

post '/line' do
  params = JSON.parse(request.body.read)
  h = HTTPClient.new
  content = {
    toChannel: channel,
    eventType: type,
    content: {
      contentType: 1,
      toType: 1,
      text: 'どんどん'
    }
  }

  h.post(url, content, headers)
end
