{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    gnome-disk-utility
    udiskie # removable disk automounter for udisks
  ];
}
