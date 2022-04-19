require 'net/http'
require 'json'

class SpotifyAPI
  REFRESH_TOKEN = ENV.fetch("SPOTIFY_REFRESH_TOKEN")
  CLIENT_ID = ENV.fetch("SPOTIFY_CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  def initialize(initial_volume:)
    @initial_volume = initial_volume

    refresh_access_token
    reset_volume
  end

  def play
    play_url = URI("https://api.spotify.com/v1/me/player/play")

    put_request(play_url)
  end

  def pause_with_fade_out
    fade_out_volume
    pause
    reset_volume
  end

  private

  def reset_volume
    set_volume(@initial_volume)
  end

  def fade_out_volume
    (@current_volume / 2).times do |i|
      set_volume(@current_volume - i * 2)
    end
  end

  def set_volume(volume)
    set_volume_url = URI("https://api.spotify.com/v1/me/player/volume?volume_percent=#{volume}")

    put_request(set_volume_url)

    @current_volume = volume
  end

  def pause
    pause_url = URI("https://api.spotify.com/v1/me/player/pause")

    put_request(pause_url)
  end

  def refresh_access_token
    url = URI("https://accounts.spotify.com/api/token")
    body = {
      grant_type: "refresh_token",
      refresh_token: REFRESH_TOKEN,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET
    }

    json_response = Net::HTTP.post_form(url, body)
    response = JSON.parse(json_response.body)

    @access_token = response["access_token"]
  end

  def put_request(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(url)

    request["content-type"] = "application/json"
    request["accept"] = "application/json"
    request["Authorization"] = "Bearer #{@access_token}"

    http.request(request)
  end
end
