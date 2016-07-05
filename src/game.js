import Board from "./states/Board"

export default class Game extends Phaser.Game {
  constructor(){
      super(800, 1200, Phaser.AUTO, '', null)
      this.state.add('Board', Board, false)
      this.state.start('Board')
  }
}
