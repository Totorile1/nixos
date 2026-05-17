{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # used for the framework 16 laptop
    framework-tool
    framework-tool-tui
  ];
}
