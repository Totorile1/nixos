{
  config,
  pkgs,
  ...
}: {
  programs.thunderbird = {
    enable = true;
    profiles.tomasr = {
      isDefault = true;
    };
  };
}
