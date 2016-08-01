export Video:
  choose-video: (sprite) !->
    {scaleX, scaleY} = sprite.video
    video = @game.add.video sprite.name
    video.play true
    sprite = video.add-to-world 0,0,0,0,scaleX,scaleY
    @current-video = { sprite, video }

  close-video: !->
    if @current-video?
      {sprite, video} = @current-video
      video.stop!
      video.current-time = 0.3
      sprite.destroy!
      delete @current-video
