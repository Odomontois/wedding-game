export default class Board extends Phaser.State{
  preload () {
    const {game} = this
    game.load.image('selfie', 'photos/selfie.jpg')
    game.load.image('bg', "images/background.jpg")
    game.load.json('stages', 'data/stages.json')
    const stages = game.cache.getJSON('stages')
    for ([name, {photo}] of Object.entries(stages)){
      game.load.image(`stage_{name}`, `photos/{photo}`)
    }
  }

  drawStage({x,y,photo,crop}){
    const pic = this.game.add.sprite(x,y, `stage_{name}`)
  }

  create() {
      const {game} = this
      game.add.sprite(0,0,"bg")

      const stages = game.cache.getJSON('stages');
      console.log(stages);

      for(const [name, stage] of Object.entries(stages)){
        console.log(name, stage)
      }
  }

  render(){
  }
}
