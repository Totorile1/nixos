{ config, pkgs, ... }:

{
	#refer to https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
	wayland.windowManager.hyprland.enable = true;

	#hint Electron apps to use on wayland;
	home.sessionVariables.NIXOS_OZONE_WL="1"
}
