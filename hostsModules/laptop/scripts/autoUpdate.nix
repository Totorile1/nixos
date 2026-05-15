{
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "custom-autoupdate";

  runtimeInputs = with pkgs; [
    git
    nixos-rebuild
    matrix-commander-rs
    libnotify
  ];

  text = ''
    set -e

    FLAKE_DIR="/home/tomasr/nixos"
    FLAKE="$FLAKE_DIR#laptop"
    TIME=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

    git -C "$FLAKE_DIR" pull
    git -C "$FLAKE_DIR" tag "pre-autoupdate-$TIME"

    nix flake update --flake "$FLAKE_DIR"

    if sudo nixos-rebuild switch --flake "$FLAKE"; then
      git -C "$FLAKE_DIR" add flake.lock
      git -C "$FLAKE_DIR" commit -m "flake: autoupdate $TIME"
      git -C "$FLAKE_DIR" push

      notify-send "Flake autoupdate" "Rebuild OK"
      matrix-commander-rs -m "Flake rebuild OK"
    else
      notify-send -u critical "Flake autoupdate" "FAILED"
      matrix-commander-rs -m "Flake rebuild FAILED"
      git reset --hard "pre-autoupdate-$TIME"
    fi
  '';
}
