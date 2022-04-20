require_relative 'spotify_player'
require_relative 'pomodoro'

minutes = (ARGV[0] || 25).to_f
notify_of_end = ARGV[1] == "notify"

Pomodoro.new(media_player: SpotifyPlayer.new(initial_volume: 50)).run(minutes: minutes, notify_of_end: notify_of_end)
