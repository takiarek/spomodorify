require 'net/http'
require 'json'

class SpotifyAccount
  REFRESH_TOKEN = ENV.fetch("SPOTIFY_REFRESH_TOKEN")
  CLIENT_ID = ENV.fetch("SPOTIFY_CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  def initialize
    refresh_access_token
  end

  def access_token
    refresh_access_token if access_token_age >= 45*60

    @access_token
  end

  private

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

    @access_token_refreshed_at = Time.now
    @access_token = response["access_token"]
  end

  def access_token_age
    Time.now - @access_token_refreshed_at
  end
end
