MaskSub =
  make-mask: ->
  draw-frame: ->

class MaskImpl implements MaskSub
  (@state, @sprite) ->
    sprite.maskHandler = this

    {x,y, width : w, height : h} = sprite
    @pos = {x,y,w,h}
    @crop = {} <<< sprite.cropRect

    @mask = @make-mask!
    @frame = @draw-frame!
    @scale = {} <<< this.sprite.scale
    @sprite.mask = @mask


  game:~ -> @state.game

  tween: (obj, to, start) ->
    @game.add.tween(obj).to(to, ...@tween-params start)

  enlarge: (start = true) ->
    console.log(this.sprite._crop)
    {width, height} = @game

    @sprite.mask = null
    @mask.visible = false
    @frame?visible = false
    @tween this.sprite.cropRect, {x: 0, y: 0, width, height},  start
      ..onStart.add ~> @tween @sprite, (x: 0, y: 0), start
      ..onStart.add ~> @tween @sprite.scale, (x: 1, y: 1), start

  shrink: (start = true) ->
    rest = [1000, "Linear", true]
    {x,y,w,h} = @pos

    tween = @tween @sprite, {x, y}, start
    tween.onStart.add ~> @tween @sprite.cropRect, @crop, start
    tween.onStart.add ~> @tween @sprite.scale, @scale, start
    tween.onComplete.add ~>
      @sprite.mask = @mask
      @mask.visible = true
      @frame?visible = true

    tween


  tween-params: (autoStart) -> [1000, "Linear", autoStart]

class circle extends MaskImpl
  make-mask: ->
    mask = @game.add.graphics 0 0
    {x, y, width: w, height: h, scale} = @sprite
    mask.beginFill(0xffffff)
    @ellipse = mask.draw-ellipse(x + w / 2, y + h / 2, w / 2, h / 2)
    @draw-frame!
    mask
  draw-frame: ->
    {x, y, width: w, height: h, scale, cfg: {border}} = @sprite
    return unless border?
    {width: bw, color: bc} = border
    frame = @game.add.graphics 0 0
    frame.line-style bw, bc
    frame.draw-ellipse(x + w / 2, y + h / 2, w/ 2 , h/ 2 )




mask-impls = {circle}
mask-maker = (state, maker, sprite) --> new maker(state, sprite)

export get-masks = (state) -> {[name, mask-maker(state, maker)] for name, maker of mask-impls}
