import Board from "states/Board"

export default class Game extends Phaser.Game {
  constructor(){
      super(1200, 900, Phaser.AUTO, '', null)
      this.state.add('Board', Board, false)
      this.state.start('Board')
  }
}
