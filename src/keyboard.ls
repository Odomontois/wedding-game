export Keyboard:
  on-press: ({key}) ->
    console.log key
    switch key
      when 'Escape'
        if @current-video?
          {sprite, video} = @current-video
          video.stop!
          sprite.destroy!
          delete @current-video
