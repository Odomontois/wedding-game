require! "game.ls" : {Game}

window.onload = ->
  $.when do
      $.getJSON "data/stages.json"
      $.getJSON "data/config.json"
  .done ([stages], [config]) ->  new Game stages, config
  .fail  (def, err) ->
    console.log err
    console.log def
