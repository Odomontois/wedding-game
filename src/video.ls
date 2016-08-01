export Video:
  choose-video: ({name, cfg: {video: {scaleX, scaleY}}}) !->
    video = @game.add.video name
    video.play true
    sprite = video.add-to-world 0,0,0,0,scaleX,scaleY
    sprite{width,height} = @game
    @current-video = { sprite, video }

  close-video: !->
    if @current-video?
      {sprite, video} = @current-video
      video.stop!
      video.current-time = 0.3
      sprite.destroy!
      delete @current-video
