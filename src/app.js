import Game from "game"

window.onload = () => {
  $.when(
      $.getJSON("/data/stages.json"),
      $.getJSON("/data/config.json")
  ).done(([stages], [config]) =>  new Game(stages, config))
};
