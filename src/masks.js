class MasksImpl{
  constructor(mixin){
    this.mixin = mixin
  }
  get game(){
    return this.mixin.game
  }
  circle(sprite){
    let {x,y,width : w, height : h} = sprite
    let mask = this.game.add.graphics(0 , 0)
    w *= sprite.scale.x
    h *= sprite.scale.y
    mask.beginFill(0xffffff)
    mask.drawEllipse(x + w / 2, y + h / 2, w / 2, h / 2)
    sprite.mask = mask
  }
}

let Masks = (cls) => class extends cls{
    masks = new MasksImpl(this)
}

export default Masks
