{
  config,
  pkgs,
  ...
}: {
  programs.obsidian = {
    enable = true;
    vaults.miscellanious = {
      enable = true;
      #target = "/kdrive/Notes/miscellanious"; #not directly to kdrive. It causes problems
      };
  };
}
