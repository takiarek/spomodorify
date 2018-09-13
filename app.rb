require 'net/http'
require 'json'

REFRESH_TOKEN=ENV.fetch("SPOTIFY_REFRESH_TOKEN")
CLIENT_ID=ENV.fetch("SPOTIFY_CLIENT_ID")
CLIENT_SECRET=ENV.fetch("SPOTIFY_CLIENT_SECRET")

VOLUME = 80

print "Refreshing access token... "

json_response = Net::HTTP.post_form(
  URI("https://accounts.spotify.com/api/token"),
  {
    grant_type: "refresh_token",
    refresh_token: REFRESH_TOKEN,
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET
  }
)
response = JSON.parse(json_response.body)

access_token = response["access_token"]

puts "Access token refreshed!"
puts
puts "ᕦ(ò_óˇ)ᕤ Time to get shit done! ᕦ(ò_óˇ)ᕤ"
puts

def put_request(url, access_token)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Put.new(url)

  request["content-type"] = 'application/json'
  request["accept"] = 'application/json'
  request["Authorization"] = "Bearer #{access_token}"

  http.request(request)
end

def set_volume(volume, access_token)
  set_volume_url = URI("https://api.spotify.com/v1/me/player/volume?volume_percent=#{volume}")

  put_request(set_volume_url, access_token)
end

set_volume(VOLUME, access_token)

start_playing_url = URI("https://api.spotify.com/v1/me/player/play")
put_request(start_playing_url, access_token)

minutes_input = ARGV[0]
minutes = (minutes_input || 25).to_i
seconds = minutes * 60
(seconds).times do |i|
  time_left = seconds - i
  puts "#{time_left / 60}:#{time_left % 60}"
  sleep 1
end

puts
puts "(ง'̀-'́)ง You did great! (ง'̀-'́)ง"
puts
puts "~(˘▾˘~) Now go get some rest. ~(˘▾˘~)"

(VOLUME / 2).times do |i|
  set_volume(VOLUME - i * 2, access_token)
end

pause_url = URI("https://api.spotify.com/v1/me/player/pause")

put_request(pause_url, access_token)
set_volume(VOLUME, access_token)

`osascript -e 'display notification "(ง'̀-'́)ง You did great! Now go get some rest. ~(˘▾˘~)" with title "Spomodorify"'` if ARGV[1] == "notify"
