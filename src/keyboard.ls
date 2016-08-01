export Keyboard:
  on-press: ({key}) ->
    console.log key
    switch key
      when 'Escape' then @close-video!
