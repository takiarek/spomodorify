require_relative 'spotify_account'
require_relative 'http_client'

class SpotifyPlayer
  URL_BASE = "https://api.spotify.com/v1/me/player"

  def initialize(initial_volume:, account: SpotifyAccount.new, http_client: HTTPClient.new)
    @initial_volume = initial_volume
    @account = account
    @http_client = http_client

    reset_volume
  end

  def play
    path = "/play"
    put_request(path)
  end

  def play_with_fade_in
    mute
    play
    fade_in_volume
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
      set_volume(@current_volume - 2)
    end
  end

  def fade_in_volume
    (@initial_volume / 2).times do |i|
      set_volume(@current_volume + 2)
    end
  end

  def set_volume(volume)
    path = "/volume?volume_percent=#{volume}"
    put_request(path)
    @current_volume = volume
  end

  def pause
    path = "/pause"
    put_request(path)
  end

  def mute
    set_volume(0)
  end

  def put_request(path)
    url = "#{URL_BASE}#{path}"
    headers = {
      "content-type" => "application/json",
      "accept" => "application/json",
      "Authorization" => "Bearer #{access_token}",
    }
    @http_client.put(url, headers)
  end

  def access_token
    @account.access_token
  end
end
