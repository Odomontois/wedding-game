export Download =
  choose-download: ({cfg: {download}}) !->
    document.createElement \a
      ..href = "data/downloads/#{ download }"
      ..download = download
      ..click!
