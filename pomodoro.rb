class Pomodoro
  def initialize(media_player:)
    @media_player = media_player
  end

  def run(minutes:, notify_of_end:)
    seconds = (minutes * 60).to_i

    puts
    puts "ᕦ(ò_óˇ)ᕤ Time to get shit done! ᕦ(ò_óˇ)ᕤ"
    puts

    @media_player.play

    (seconds * 2).times do |i|
      time_left = seconds - i
      puts "#{time_left / 60}:#{time_left % 60}" if time_left > 0
      finish_pomodoro(notify_of_end) if time_left == 0
      puts "-#{-time_left / 60}:#{-time_left % 60}" if time_left < 0
      @media_player.play_with_fade_in if time_left == -5
      sleep 1
    end

    puts "Ended at #{Time.now.strftime("%k:%M:%S")}"
  end

  private

  def finish_pomodoro(notify)
    puts
    puts "(ง'̀-'́)ง You did great! (ง'̀-'́)ง"
    puts
    puts "~(˘▾˘~) Now go get some rest. ~(˘▾˘~)"
    puts

    @media_player.pause_with_fade_out

    `osascript -e 'display notification "(ง'̀-'́)ง You did great! Now go get some rest. ~(˘▾˘~)" with title "Spomodorify"'` if notify
  end
end
