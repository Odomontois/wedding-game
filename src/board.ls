require! "masks.ls" : {get-masks}
require! "prelude-ls": {sort-by, obj-to-pairs}
require! "text.ls": {Text}

export class Board extends Phaser.State implements Text
  preload: ->
    {game} = @
    @masks = get-masks(@)
    game.load.image 'bg' game.cfg.background
    for name, {photo} of game.stages
      if photo?
        game.load.image("stage_#{ name }", "data/photos/#{ photo }")

      game.load.text("text_#{name}", "data/texts/#{ name }.txt")

  drawStage: (name, {at: [x,y] ,photo, crop, mask, scale}) ->
    pic = @game.add.sprite x,y, "stage_#{name}"
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

      for [name, stage] in ord-stages
        sprite = @draw-stage(name, stage)
        @stages[name] = sprite
        sprite.name = name
        stage.type =
          if stage.video?
            sprite.video = stage.video
            "video"
          else "text"

  update: ->
    for _,stage of @stages
      stage.update-crop!

  show-unchosen: (visible = false)->
    for _,stage of @stages
      if stage != @chosen then stage.visible = visible

  chooseStage: (sprite)->
    console.log sprite

    switch stage.type
      when "text" then @chooseText sprite
      when "video" then @chooseVideo sprite

  chooseVideo: (sprite) ->
    s

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
