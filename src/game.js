import Board from "states/Board"

export default class Game extends Phaser.Game {
  constructor(stages, config){
      const {width, height} = config
      super(width, height, Phaser.AUTO, '', null)
      this.state.add('Board', Board, false)
      this.state.start('Board')
      this.stages = stages
      this.config = config
  }
}
