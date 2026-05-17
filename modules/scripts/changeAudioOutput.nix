{
  writeShellApplication,
  fzf,
  pactl,
  jq,
  ...
}:
writeShellApplication {
  name = "custom-changeAudioOutput";
  runtimeInputs = [
    fzf
    pactl
    jq
  ];
  text = ''
    $select=pactl -f json list sinks | jq -r '.[].name' | fzf
    if [[ -n "$select" ]]; then
      pactl set-default-sink $select
    fi
  '';
}
