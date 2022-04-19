require_relative 'http_client'

class SpotifyAccount
  REFRESH_TOKEN = ENV.fetch("SPOTIFY_REFRESH_TOKEN")
  CLIENT_ID = ENV.fetch("SPOTIFY_CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  def initialize(http_client: HTTPClient.new)
    @http_client = http_client
    refresh_access_token
  end

  def access_token
    refresh_access_token if access_token_expired?

    @access_token
  end

  private

  def refresh_access_token
    url = "https://accounts.spotify.com/api/token"
    body = {
      grant_type: "refresh_token",
      refresh_token: REFRESH_TOKEN,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
    }

    response = @http_client.post(url, body)
    @access_token_refreshed_at = Time.now

    response_body = JSON.parse(response.body)
    @access_token_expiry_time = response_body["expires_in"] - 10
    @access_token = response_body["access_token"]
  end

  def access_token_expired?
    access_token_age >= @access_token_expiry_time
  end

  def access_token_age
    Time.now - @access_token_refreshed_at
  end
end
