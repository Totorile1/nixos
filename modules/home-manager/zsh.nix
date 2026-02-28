{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    initContent = "fastfetch\n";
    shellAliases = {
	".." = "z ..";
	grep = "rg";
	ll = "ls -alF";
	la = "ls -A";
	l = "ls -CF";
	ls = "ls -hA -s --color";
    };
  };
}
