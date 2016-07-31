export Video:
  chooseVideo: (sprite) ->
    {scaleX, scaleY} = sprite.video
    video = @game.add.video sprite.name
    video.play true
    sprite = video.add-to-world 0,0,0,0,scaleX,scaleY
    @current-video = { sprite, video }
