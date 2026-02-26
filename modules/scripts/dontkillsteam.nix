{ writeShellApplication, hyprland, jq, ... }:

writeShellApplication {
	name = "custom-dontkillsteam";
	runtimeInputs = [
		hyprland
		jq
	];
	text = ''
		if [[ $(hyprctl activewindow -j | jq -r ".class") == "Steam" ]]; then
			hyprctl dispatch minimize
		else
			hyprctl dispatch killactive ""
		fi

	'';
}
