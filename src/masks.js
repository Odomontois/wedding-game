class MaskImpl {
  constructor(state, sprite){
    this.state = state
    this.sprite = sprite
    sprite.maskHandler = this

    let {x,y, width : w, height : h} = sprite
    this.pos = {x,y,w,h}
    this.crop = Object.assign({}, sprite.cropRect)

    this.mask = this.makeMask()
    this.scale = Object.assign({}, this.sprite.scale)
    this.sprite.mask = this.mask
  }

  get game(){
    return this.state.game
  }

  tween(obj, to, start){
    return this.game.add.tween(obj).to(to, ...this.tweenParams(start))
  }

  enlarge(start = true){
    console.log(this.sprite._crop)
    const {width, height} = this.game

    this.sprite.mask = null
    this.mask.visible = false
    const tween = this.tween(this.sprite.cropRect,{x: 0, y: 0, width, height},  start)
    tween.onStart.add(() => this.tween(this.sprite,{x: 0, y: 0}, start))
    tween.onStart.add(() => this.tween(this.sprite.scale, {x: 1, y: 1}, start))
    return tween
  }

  shrink(start = true){
    const rest = [1000, "Linear", true]
    const {x,y,w,h} = this.pos

    const tween = this.tween(this.sprite, {x, y}, start)
    tween.onStart.add(() => this.tween(this.sprite.cropRect, this.crop, start))
    tween.onStart.add(() => this.tween(this.sprite.scale, this.scale, start))
    tween.onComplete.add(() => {
      this.sprite.mask = this.mask
      this.mask.visible = true
    })
    return tween
  }

  tweenParams(autoStart) {
    return [1000, "Linear", autoStart]
  }
}

class circle extends MaskImpl{
  makeMask(){
    const mask = this.game.add.graphics(0 , 0)
    const {x, y, width, height, scale} = this.sprite
    const w = width * scale.x
    const h = height * scale.y
    mask.beginFill(0xffffff)
    this.ellipse = mask.drawEllipse(x + w / 2, y + h / 2, w / 2, h / 2)
    return mask
  }
}

const maskImpls = {circle}

function makeMasks(state){
  const masks = {}
  for([name, maker] of Object.entries(maskImpls)){
    masks[name] = (sprite) => new maker(state, sprite)
  }
  return masks
}

let Masks = (cls) => class extends cls{
    masks = makeMasks(this)
}

export default Masks
