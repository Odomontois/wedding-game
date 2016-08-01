export Keyboard:
  on-press: ({key}) ->
    console.log key
    if key of @key-handlers
       @choose-stage @key-handlers[key]
    else switch key
      when /*'Escape'*/ 'q' or 'й'  then @close-video!
      when 'F2'
        if @game.scale.is-full-screen
          @game.scale.stop-full-screen!
        else @game.scale.start-full-screen!

  reg-key-handlers: !->
    @key-handlers = {[key, sprite] for ,{config:{key}, sprite} of @stages when key?}
