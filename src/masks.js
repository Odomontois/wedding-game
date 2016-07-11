class MaskImpl {
  constructor(state, sprite){
    this.state = state
    this.sprite = sprite
    sprite.maskHandler = this
  }
  get game(){
    return this.state.game
  }
}

class circle extends MaskImpl{
  constructor(state, sprite){
    super(state, sprite)
    let {x,y, width : w, height : h} = sprite
    this.pos = {x,y,w,h}
    this.crop = Object.assign({}, sprite.cropRect)
    this.mask = this.game.add.graphics(0 , 0)
    w *= sprite.scale.x
    h *= sprite.scale.y
    this.mask.beginFill(0xffffff)
    this.ellipse = this.mask.drawEllipse(x + w / 2, y + h / 2, w / 2, h / 2)
    sprite.mask = this.mask
  }

  enlarge(){
    console.log(this.sprite._crop)
    const {width, height} = this.game
    const rest = [1000, "Linear", true]
    this.sprite.mask = null
    this.mask.visible = false
    this.game.add.tween(this.sprite.cropRect).to({x: 0, y: 0, width, height},  ...rest)
    return this.game.add.tween(this.sprite).to({x: 0, y: 0}, ...rest)
  }

  shrink(){
    const rest = [1000, "Linear", true]
    const {x,y,w,h} = this.pos
    this.game.add.tween(this.sprite.cropRect).to(this.crop,  ...rest)
    const tween = this.game.add.tween(this.sprite).to({x, y}, ...rest)
    tween.onComplete.add(() => {
      this.sprite.mask = this.mask
      this.mask.visible = true
    })
    return tween
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
