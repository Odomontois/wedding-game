import stages from "data/stages.json"
import Masks  from "masks.js"

@Masks
export default class Board extends Phaser.State{
  preload () {
    const {game} = this
    game.load.image('selfie', 'photos/selfie.jpg')
    game.load.image('bg', "images/background.jpg")
    for ([name, {photo}] of Object.entries(stages)){
      if(photo){
        game.load.image(`stage_${ name }`, `photos/${ photo }`)
      }
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
  }

  create() {
      const {game} = this
      game.add.sprite(0,0,"bg")

      console.log(stages);

      for(const [name, stage] of Object.entries(stages)){
        this.drawStage(name, stage)
      }
  }

  chooseStage(sprite) {
    console.log(sprite)
  }
}
