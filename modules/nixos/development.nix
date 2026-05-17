{
  pkgs,
  ...
}:
{
  programs.nix-ld.enable = true; #Run unpatched dynamic binaries on NixOS. For example lets run ./a.out from gcc
  environment.systemPackages = with pkgs; [
    gcc
    jq # json parser used in some scripts
    (pkgs-unstable.python314.withPackages (ps:
      with ps; [
        matplotlib
        networkx
        scipy
      ]))
    direnv
    cling # c interpreter used for coding
    # lsp
    clang-tools
    python311Packages.python-lsp-server
    ltex-ls-plus
    pylint
    black
  ];
}
