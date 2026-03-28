{
  writeShellApplication,
  zsh,
  fzf,
  ripgrep,
  ...
}:

writeShellApplication {
  name = "custom-obsidianvaults";
  runtimeInputs = [
    zsh
    fzf
    ripgrep
  ];
  text = ''
    # Path to your obsidian.nix
    obsidian_nix="$HOME/nixos/modules/home-manager/obsidian.nix"

    # Extract vault names without line numbers and colors
    mapfile -t vaults < <(rg -N --color=never -Po 'vaults\.\K[[:alnum:]_]+' "$obsidian_nix")

    # Let user select a vault with fzf
    selected=$(printf "%s\n" "''${vaults[@]}" \
      | fzf --height 6 --reverse --prompt="Select Obsidian vault:")

    # Exit if user cancels
    [[ -z "$selected" ]] && exit 0

    # Remove any stray ANSI codes (optional)
    selected=$(echo "$selected" | sed -r 's/\x1B\[[0-9;]*[mK]//g')

    # Find the target path of the selected vault
    vault_path=$(rg -N --color=never -A2 "vaults.$selected" "$obsidian_nix" \
      | rg 'target =' | sed -E 's/.*"([^"]+)".*/\1/')

    # Expand ~ if present
    vault_path="''${vault_path/#\~/$HOME}"

    # Launch Obsidian with the selected vault using URI
    [[ -n "$vault_path" ]] && setsid xdg-open "obsidian://open?vault=$selected" >/dev/null 2>&1 &
    # Exit the kitty terminal after selection
    pkill -f "kitty.*Select Obsidian vault"
    exit
    '';
}
