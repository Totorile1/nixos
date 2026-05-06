# see also ../nixos/mullvad.nix
{
  ...
}: {
  programs.mullvad-vpn = {
    enable = true;
    # see https://github.com/mullvad/mullvadvpn-app/blob/main/desktop/packages/mullvad-vpn/src/main/gui-settings.ts for options
    settings = {
      autoConnect = true;
      autoStart = true;
    };
  };
}
