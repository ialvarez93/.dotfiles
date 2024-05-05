# Ivan's dotfiles


## About  (WIP)<a name = "about"></a>

This is a flake configuration for NixOS with KDE plasma 6


### Switch

This is for when you change the system configuration.

```bash
sudo nixos-rebuild switch --flake ./#default
```

### Upgrade

This is for when you want to update the current packages in the system configuration.

```bash
sudo nixos-rebuild switch --upgrade --flake ./#default
```


## Note <a name = "usage"></a>

This is a WIP. 
