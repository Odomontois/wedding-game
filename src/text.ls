export Text =
  make-text: (sprite)->
    content = @game.cache.get-text sprite.name
    {centerX, centerY, x, y, width, height} = @game.world
    text = @game.add.text(0, 0, content)
    text.align = 'center'
    text.bounds-align-h = 'center'
    text.bounds-align-v = 'center'
    text.set-text-bounds(x,y,width, height)

    text.font-size = 30
    text.fill = '#ffffff'

    text.stroke = '#000000'
    text.stroke-thickness = 10

    sprite.text = text

  chooseText: (sprite)->
    if sprite == @chosen
      @chosen = null
      visible = true
      sprite.text.destroy()
      sprite.maskHandler.shrink().onComplete.add  ~> @show-unchosen true
    else
      @chosen = sprite
      @showUnchosen false
      sprite.maskHandler.enlarge().onComplete.add  ~> @make-text sprite
