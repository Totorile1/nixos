{ writeShellApplication, socat, swww, ... }:

writeShellApplication {
	name = "custom-wallpaper";
	runtimeInputs = [
		socat
		swww
	];
	text = ''
handle() {
  case $1 in
    workspace*)
      str=$1
      i=$((''${#str}-1))
      workspace="''${str:$i:1}"
      case $workspace in
        1 | 6)
          swww img -t none ../../assets/wallpaper1.jpg
          ;;
        2 | 7)
          swww img  -t none ../../assets/wallpaper2.jpg
          ;;
        3 | 8)
          swww img  -t none ../../assets/wallpaper3.jpg
          ;;
        4 | 9)
          swww img  -t none ../../assets/wallpaper4.jpg
          ;;
        5 | 10)
          swww img  -t none ../../assets/wallpaper5.jpg
          ;;
      esac
      ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done	
	'';
}
