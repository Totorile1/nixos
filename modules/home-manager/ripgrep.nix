{ config, pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "-S"
      "-."
      "-p"
      "-n"
      "-c"
    ];
  };
  programs.ripgrep-all = {
      enable = true;
  };

}
