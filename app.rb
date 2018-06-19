require 'net/http'

sleep 60*25

100.times do |i|
  url = URI("https://api.spotify.com/v1/me/player/volume?volume_percent=#{100-i}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Put.new(url)
  request["content-type"] = 'application/json'
  request["accept"] = 'application/json'
  request["Authorization"] = "Bearer #{ENV["SPOTIFY_API_TOKEN"]}"

  http.request(request)
  sleep 2/100
end
