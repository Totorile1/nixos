{
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "custom-cleanNix";

  runtimeInputs = with pkgs; [
    git
    nixos-rebuild
    matrix-commander-rs
    libnotify
    alejandra
    deadnix
  ];

  text = ''
    set -e

    FLAKE_DIR="/home/tomasr/nixos"
    FLAKE="$FLAKE_DIR#laptop"
    TIME=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

    ERROR_FILE=$(mktemp)

    # snapshot current state
    git -C "$FLAKE_DIR" add -A
    git -C "$FLAKE_DIR" commit --allow-empty -m "snapshot pre-cleanup-$TIME"
    git -C "$FLAKE_DIR" tag "pre-cleanup-$TIME" HEAD

    # removes dead code
    deadnix --edit "$FLAKE_DIR" # removes unused code
    statix fix "$FLAKE_DIR" # check other linting issues
    alejandra "$FLAKE_DIR" # formats the config

    if sudo /run/current-system/sw/bin/nixos-rebuild switch --flake "$FLAKE" 2> "$ERROR_FILE"; then # use /run/.../bin/ uses the sudoless rule
    
      if ! git -C "$FLAKE_DIR" diff --quiet HEAD; then
        git -C "$FLAKE_DIR" add -A
        git -C "$FLAKE_DIR" commit -m "Auto: cleanup-$TIME"
        git -C "$FLAKE_DIR" push

        notify-send "Nix auto cleanup" "Everything OK"

        matrix-commander-rs --verbose -m "Nix auto cleanup. Everything OK.<br><a href=\"https://matrix.to/#/@notificationbot_0000:matrix.org\">@notificationbot_0000</a>" \
          --html \
          -r "\!7j-78_02dHROeLj4Ns8F12eo4IiZGv4zNsQ_1-WlyIU"
        else
          notify-send "Nix auto cleanup" "No changes"
          git -C "$FLAKE_DIR" push
        fi

    else
      ERROR_MSG=$(cat "$ERROR_FILE")

      notify-send -u critical "Nix auto cleanup" "FAILED"

      matrix-commander-rs --verbose -m "Nix auto cleanup failed.<br>Error: <pre>$ERROR_MSG</pre><br><a href=\"https://matrix.to/#/@notificationbot_0000:matrix.org\">@notificationbot_0000</a>" \
        --html \
        -r "\!7j-78_02dHROeLj4Ns8F12eo4IiZGv4zNsQ_1-WlyIU"

      git -C "$FLAKE_DIR" reset --hard "pre-cleanup-$TIME"
    fi
    git -C "$FLAKE_DIR" tag -d "pre-cleanup-$TIME" # removes the tag
    
    rm -f "$ERROR_FILE"
  '';
}
