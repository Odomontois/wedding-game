export default class Board extends Phaser.State{
  preload () {
    this.game.load.image('selfie', 'photos/selfie.jpg')
  }

  create() {
      const {game} = this
      const logo = game.add.sprite(game.world.centerX, game.world.centerY, 'selfie')
      logo.anchor.setTo(0.5, 0.5)
  }
}
