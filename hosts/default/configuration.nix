# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
    inputs.home-manager.nixosModules.default
  ];

  # Nix settings
  nix = {
    # Store optimization
    optimise = {
      automatic = true;
      dates = ["13:00"];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store on build
      auto-optimise-store = true;
    };
  };

  # nixpkgs instance config
  nixpkgs = {
    config = {
      # Always allow unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # For nvidia drivers
      nvidia.acceptLicense = true;
      # For obsidian
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

  # Bootloader.d
  boot.kernel.sysctl = {"vm.swappiness" = 0;};
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rocinante"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };
  # Enable japanese input
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    # pkgs.fcitx5-anthy
    pkgs.fcitx5-mozc
    pkgs.fcitx5-gtk
    pkgs.fcitx5-configtool
  ];
  environment.variables.GTK_IM_MODULE = "fcitx";
  environment.variables.QT_IM_MODULE = "fcitx";
  environment.variables.XMODIFIERS = "@im=fcitx";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasmax11";
    autoLogin.enable = true;
    autoLogin.user = "ivan";
  };
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    oxygen
  ];
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan Alvarez";
    extraGroups = ["networkmanager" "wheel" "kvm" "adbusers" "docker"];
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "ivan" = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # Utilities
    wget
    curl
    lshw
    alejandra
    nil
    gh
    unrar
    p7zip
    # Internet
    firefox
    qbittorrent
    telegram-desktop
    discord
    # Development
    fira-code-nerdfont
    obsidian
    vscode-fhs
    docker-compose
    android-studio
    android-udev-rules
    ## Elixir
    livebook
    # Design
    krita
    inkscape-with-extensions
    blender
    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.es_VE
    hunspellDicts.en_US
    ## For Kate
    aspell
    aspellDicts.es
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    calibre
    # Japanese
    noto-fonts-cjk-sans
    anki
    # Media
    mpv
    libsForQt5.kdenlive
    isoimagewriter
    kdePackages.partitionmanager
  ];

  # For Android development
  programs.adb.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add any missing dynamic libraries for unpackaged programs
  #   # here, NOT in environment.systemPackages
  # ];

  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Auto system update
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    channel = "https://channels.nixos.org/nixos-24.05";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.syncthing = {
    enable = true;
    dataDir = "/home/ivan";
    openDefaultPorts = true;
    configDir = "/home/ivan/.config/syncthing";
    user = "ivan";
    group = "users";
    guiAddress = "127.0.0.1:8384";
    # declarative = { SNIPPED };
  };

  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
