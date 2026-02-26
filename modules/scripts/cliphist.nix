{ writeShellApplication
, cliphist
, rofi
, wl-clipboard
}:

writeShellApplication {
  name = "custom-cliphist";

  runtimeInputs = [
    cliphist      # clipboard manager
    rofi          # launcher menu
    wl-clipboard  # wl-copy
  ];

  text = ''
    set -euo pipefail

    action="${1:-}"

    case "$action" in
      c|-c|--copy)
        cliphist list |
          rofi -dmenu" |
          cliphist decode |
          wl-copy
        ;;

      d|-d|--delete)
        cliphist list |
          rofi -dmenu" |
          cliphist delete
        ;;

      w|-w|--wipe)
        if [[ "$(printf "Yes\nNo" | rofi -dmenu")" == "Yes" ]]; then
          cliphist wipe
        fi
        ;;

      *)
        echo "custom-cliphist [action]"
        echo "c -c --copy    : list and copy selected"
        echo "d -d --delete  : list and delete selected"
        echo "w -w --wipe    : wipe clipboard database"
        exit 1
        ;;
    esac
  '';
}
