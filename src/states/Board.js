import Masks  from "masks.js"

@Masks
export default class Board extends Phaser.State{
  preload () {
    const {game} = this
    game.load.image('selfie', 'data/photos/selfie.jpg')
    game.load.image('bg', "images/background.jpg")
    for ([name, {photo}] of Object.entries(game.stages)){
      if(photo){
        game.load.image(`stage_${ name }`, `data/photos/${ photo }`)
      }
      game.load.text(`text_${name}`, `data/texts/${ name }.txt`)
    }
  }

  drawStage(name, {at: [x,y] ,photo, crop, mask, scale}){
    const pic = this.game.add.sprite(x,y, `stage_${name}`)
    if (crop) {
      pic.crop(new Phaser.Rectangle(...crop))
    }
    if(scale) {
      [x,y] = scale
      pic.scale = {x,y}
    }
    if(mask) {
      this.masks[mask](pic)
    }
    pic.inputEnabled = true;

    pic.events.onInputDown.add(this.chooseStage, this);

    return pic
  }

  create() {
      const {game} = this
      game.add.sprite(0,0,"bg")
      this.stages = {}

      for(const [name, stage] of Object.entries(game.stages)){
        let sprite = this.drawStage(name, stage)
        this.stages[name] = sprite
        sprite.name = name
      }
  }

  update(){
    for(let stage of Object.values(this.stages)){
      stage.updateCrop()
    }
  }

  showUnchosen(visible = false){
    for(let stage of Object.values(this.stages)){
      if(stage !== this.chosen) stage.visible = visible;
    }
  }

  makeText(sprite){
    const {game} = this
    const content = game.cache.getText(`text_${sprite.name}`)
    const {centerX, centerY, x, y, width, height} = this.game.world
    const text = game.add.text(0, 0, content)
    text.align = 'center'
    text.boundsAlignH = 'center'
    text.boundsAlignV = 'center'
    text.setTextBounds(x,y,width, height)


    text.fontSize = 30
    text.fill = '#ffffff'

    text.stroke = '#000000'
    text.strokeThickness = 10

    sprite.text = text
  }

  chooseStage(sprite) {
    console.log(sprite)
    let visible = false
    if(sprite === this.chosen) {
      this.chosen = null
      visible = true
      sprite.text.destroy()
      sprite.maskHandler.shrink().onComplete.add(() => this.showUnchosen(true))
    } else {
      this.chosen = sprite
      this.showUnchosen(false)
      sprite.maskHandler.enlarge().onComplete.add(() => this.makeText(sprite))
    }
  }
}
