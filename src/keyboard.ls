export Keyboard:
  on-press: ({key}) ->
    console.log key
    if key of @key-handlers
       @choose-stage @key-handlers[key]
    else switch key
      when 'Escape' then @close-video!

  reg-key-handlers: !->
    @key-handlers = {[key, sprite] for ,{config:{key}, sprite} of @stages when key?}
