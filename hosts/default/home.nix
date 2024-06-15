{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ivan";
  home.homeDirectory = "/home/ivan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello
    # starship
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    #(pkgs.nerdfonts.override {fonts = ["FiraCode"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ivan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "vi";
    # VISUAL = "vi";
  };

  home.shellAliases = {
    g = "git";
    "..." = "cd ../..";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "ivalvarez22@gmail.com";
    userName = "Ivan Alvarez";
    extraConfig = {
      init.defaultBranch = "trunk";
      safe.directory = "/home/ivan/.dotfiles";
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    #Starship
    starship.enable = true;

    bash = {
      enable = true;
      # This writes to .bashrc KISS
      # Dev must be shell.nix per project
      # bashrcExtra = "";
    };
  };

  programs.eza.enable = true;
  programs.eza.icons = true;
  programs.eza.git = true;

  programs.kakoune.enable = true;
  programs.kakoune.defaultEditor = true;
  programs.kakoune.config.numberLines.enable = true;
  programs.kakoune.config.numberLines.relative = true;
  programs.kakoune.config.numberLines.highlightCursor = true;
  programs.kakoune.config.ui.assistant = "cat";
  programs.kakoune.config.ui.enableMouse = true;
  programs.kakoune.plugins = with pkgs; [
    kakounePlugins.kak-fzf
  ];

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    prefix = "C-a";
    # keyMode = "vi";
  };
}
