require! "board.ls" : {Board}
require! "prelude-ls": {sort-by}
export class Game extends Phaser.Game
  (@stages, @cfg) ->
      {width, height} = cfg
      super(width, height, Phaser.AUTO, '', null)
      @state.add('Board', Board, false)
      @state.start('Board')
