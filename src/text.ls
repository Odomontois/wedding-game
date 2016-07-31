export Text =
  make-text: (sprite)->
    {game} = this
    content = game.cache.get-text("text_#{sprite.name}")
    {centerX, centerY, x, y, width, height} = this.game.world
    text = game.add.text(0, 0, content)
    text.align = 'center'
    text.bounds-align-h = 'center'
    text.bounds-align-v = 'center'
    text.set-text-bounds(x,y,width, height)

    text.fontSize = 30
    text.fill = '#ffffff'

    text.stroke = '#000000'
    text.strokeThickness = 10

    sprite.text = text
