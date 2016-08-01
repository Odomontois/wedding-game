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
    for name, {photo, video, text} of @game.stages
      if photo? then @game.load.image name, "data/photos/#{ photo }"
      if video? then @game.load.video name, "data/videos/#{ video.name }"
      if text? then  @game.load.text  name, "data/texts/#{ text }"

  drawStage: (name, {at: [x,y] ,photo, crop, mask, scale}) ->
    pic = @game.add.sprite x,y, name
    if crop? then pic.crop new Phaser.Rectangle ...crop

    if scale?
      [x,y] = scale
      pic.scale = {x,y}

    if mask? then  @masks[mask](pic)

    pic.input-enabled = true
    pic.events.on-input-down.add @chooseStage, @
    pic

  create: !->
      @game.add.sprite 0 0 "bg"
      @stages = {}
      ord-stages = sort-by (.1.index), obj-to-pairs @game.stages
      @input.keyboard.on-down-callback = @~on-press

      for [name, config] in ord-stages
        sprite = @draw-stage(name, config)
        @stages[name] = {sprite, config}
        sprite.cfg = config
        sprite.name = name
        sprite.type =
          if config.video? then  "video"
          else if config.download? then "download"
          else "text"

      @reg-key-handlers!

  update: ->
    for ,{sprite} of @stages
      sprite.update-crop!

  show-unchosen: (visible = false)->
    for  ,{sprite} of @stages
      if sprite != @chosen then sprite.visible = visible

  chooseStage: (sprite)->
    console.log sprite

    switch sprite.type
      when "text" then @choose-text sprite
      when "video" then @choose-video sprite
      when "download" then @choose-download sprite
