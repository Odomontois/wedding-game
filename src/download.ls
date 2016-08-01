export Download =
  choose-download: (sprite) !->
    document.createElement \a
      ..href = "data/downloads/#{ sprite.download }"
      ..download = sprite.download
      ..click!
