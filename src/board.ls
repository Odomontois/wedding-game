require! "masks.ls" : {get-masks}
require! "prelude-ls": {sort-by, obj-to-pairs}
require! "text.ls": {Text}
require! "video.ls" : {Video}
require! "keyboard.ls": {Keyboard}
require! "download.ls": {Download}

export class Board extends Phaser.State implements Text, Video, Keyboard, Download
  preload: ->
    @masks = get-masks(@)
    @game.load.image 'bg' @game.cfg.background
    for name, {photo, video, text, title} of @game.stages
      if photo? then @game.load.image name, "data/photos/#{ photo }"
      if video? then @game.load.video name, "data/videos/#{ video.name }"
      if text? then  @game.load.text  name, "data/texts/#{ text }"

  drawStage: (name, {at: [x,y] ,photo, crop, mask, scale}:cfg) ->
    sprite = @game.add.sprite x,y, name
    sprite <<< {cfg}
    if crop? then sprite.crop new Phaser.Rectangle ...crop

    if scale?
      [x,y] = scale
      sprite.scale = {x,y}

    if mask? then  @masks[mask](sprite)

    sprite.input-enabled = true
    sprite.events.on-input-down.add @chooseStage, @
    sprite

  create: !->
      @game.add.sprite 0 0 "bg"
      @stages = {}
      ord-stages = sort-by (.1.index), obj-to-pairs @game.stages
      @input.keyboard.on-down-callback = @~on-press

      for [name, config] in ord-stages
        sprite = @draw-stage(name, config)
        @stages[name] = {sprite, config}

        sprite <<< {name}
        sprite.type =
          if config.video? then  "video"
          else if config.download? then "download"
          else if config.text? or config.caption? then "text"
          else "nothing"

      @reg-key-handlers!
      @game.scale.compatibility.no-margins = true
      @game.scale.full-screen-scale-mode = Phaser.ScaleManager.EXACT_FIT

  update: !->
    for ,{sprite: {mask-handler}} of @stages
      mask-handler?update!

  show-unchosen: (visible = false)->
    for  ,{sprite} of @stages
      if sprite != @chosen then sprite.visible = visible

  chooseStage: (sprite)->
    console.log sprite

    switch sprite.type
      when "text" then @choose-text sprite
      when "video" then @choose-video sprite
      when "download" then @choose-download sprite
