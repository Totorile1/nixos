# NixOS configuration
![NixOS configuraton](/assets/example.png)
###  Installation guide

⚠️ **Note:**  
Before using on another system, change:
- hostName
- if your computer is not a laptop change in ~/nixos/other/quickshell/bar/Power.qml the isLaptop variable to false. (This is a hardcoded value, because I can't get UPowerDevice.isLaptopBattery to work)

You need to have `git` installed before installing the config.
```shell
cd
git clone https://github.com/Totorile1/nixos.git
cd ./nixos
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/laptop/hardware-configuration
sudo nixos-rebuild switch --flake ~/nixos/#laptop
```


### Things that don't work reliably and need manual setting.
- Librewolf's extension's settings
- Librewolf's bookmarks
- Thunderbird's email servers
