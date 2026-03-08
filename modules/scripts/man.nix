{ writeShellApplication, man, ripgrep, fzf, ... }:

let
  cacheTime = "10";
in

writeShellApplication {
	name = "custom-man";
	runtimeInputs = [
		man
        ripgrep
        fzf
	];
    text = ''
CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_FILE="$CACHE_DIR/custom-man-options.txt"
mkdir -p "$CACHE_DIR"

REGENERATE=0

# check if -r flag was passed
if [ "''${1:-}" = "-r" ]; then
  REGENERATE=1
fi


# regenerate if file does not exist or is older than cacheTime days
if [ ! -f "$CACHE_FILE" ] || [ "$(find "$CACHE_FILE" -mtime +${cacheTime} -print)" ]; then
  REGENERATE=1
fi

if [ $REGENERATE -eq 1 ]; then
  echo "(Re)building custom-manix cache..."
  mkdir -p "$(dirname "$CACHE_FILE")"
      man -k . > "$CACHE_FILE"
fi

# read from cache and pipe into fzf
cat "$CACHE_FILE" \
  | fzf --preview "man {1}" \
  | xargs man
  '';
}
