import Game from "game"

window.onload = () => {
  $.getJSON("/data/stages.json", (stages) => new Game(stages))
};
