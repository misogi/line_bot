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

setten_t = <<EOS
ここが原点だとぉー、ここが原点だとぅー
この点はでねぇよぉ！ダメだよぉー。
誘惑振り切ってこうだ。おーん？接点ｔ！！！
EOS

def answer(text)
  if text.match(/いま何時/)
    h = (0..23).to_a.sample
    "#{h}時だぞ！"
  elsif text.match(/接点t/i)
    setten_t
  else
    'どんどん'
  end
end

get '/' do
  'OK'
end

post '/callback' do
  res = request.body.read
  params = JSON.parse(res)
  results = params['result']
  result = results[0]
  to = result['content']['from']
  text = result['content']['text']
  puts "message to #{to}"
  text_response = answer(text)
  RestClient.proxy = ENV["FIXIE_URL"]
  line_content = {
    to: [to],
    toChannel: 1383378250,
    eventType: '138311608800106203',
    content: {
      contentType: 1,
      toType: 1,
      text: text_response
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
