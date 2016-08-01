export Text =
  make-text: ({name, cfg: {caption}}: sprite) !->
    content = if caption? then caption else @game.cache.get-text name
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
      delete @chosen
      visible = true
      sprite.text.destroy!
      sprite.mask-handler.shrink!on-complete.add  ~> @show-unchosen true
    else
      @chosen = sprite
      @showUnchosen false
      sprite.mask-handler.enlarge!on-complete.add  ~> @make-text sprite
