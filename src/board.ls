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

      for [name, stage] in ord-stages
        sprite = @draw-stage(name, stage)
        @stages[name] = sprite
        sprite.name = name
        sprite.type =
          if stage.video?
            sprite.video = stage.video
            "video"
          else if stage.download
            sprite.download = stage.download
            "download"
          else "text"

  update: ->
    for _,stage of @stages
      stage.update-crop!

  show-unchosen: (visible = false)->
    for _,stage of @stages
      if stage != @chosen then stage.visible = visible

  chooseStage: (sprite)->
    console.log sprite

    switch sprite.type
      when "text" then @choose-text sprite
      when "video" then @choose-video sprite
      when "download" then @choose-download sprite
