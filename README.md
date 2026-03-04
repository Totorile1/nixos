# NixOS configuration
![NixOS configuraton](/assets/example.png)
###  Installation guide
You need to have `git` installed before installing the config.
```shell
cd
git clone https://github.com/Totorile1/nixos.git
cd ./nixos
sudo nixos-rebuild switch --flake ~/nixos/#laptop
```
### Note
The only thing which I didn't find how to setup in a declarative way are librewolf's extension. You need to do it yourself


