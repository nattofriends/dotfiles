function dc {
  if [[ -d "$1" ]]; then
    cd "$1"
  else
    command dc "$@"
  fi
}
