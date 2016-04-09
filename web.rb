require 'sinatra'
require 'json'
require 'httpclient'
require 'pp'

line_headers = {
  'Connection' => 'close',
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
  h = HTTPClient.new(ENV["FIXIE_URL"])
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

  begin
    h.post_content(line_url, body: line_content.to_json, header: line_headers)
  rescue HTTPClient::BadResponseError => e
    puts e.res.body
  rescue HTTPClient::KeepAliveDisconnected => e
    puts 'keep alive disconnected'
    pp e.sess.get_body
    pp e.sess.get_header
  end
end
