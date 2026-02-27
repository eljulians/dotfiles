{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.packages = with pkgs; [
    # Shell essentials
    ripgrep
    fzf
    bat
    fd
    autojump
    tmux
    xclip

    # Git
    git
    gh

    # Dev tools
    jq
    htop
    curl
    wget
    bc
    unimatrix
    noto-fonts-cjk-sans


    # System monitoring
    lm_sensors
    playerctl
    (writeShellScriptBin "ifstat" ''exec ${ifstat-legacy}/bin/ifstat-legacy "$@"'')

    # Fonts
    nerd-fonts.inconsolata
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code
    nerd-fonts.proggy-clean-tt
    nerd-fonts.gohufont

    # Python
    python3

    # Container tools
    docker
    docker-compose
    kubectl
  ];

  # Enable fontconfig to find Nix fonts
  fonts.fontconfig.enable = true;

  # Symlink existing dotfiles
  home.file = {
    ".aliases".source = ./aliases;
    ".functions".source = ./functions;
    ".bashrc".source = ./bashrc;
    ".zshrc".source = ./zshrc;
    ".p10k.zsh".source = ./p10k.zsh;
    ".gitconfig".source = ./gitconfig;
    ".gitignore".source = ./gitignore;
    ".tmux.conf".source = ./tmux.conf;
    ".config/tmux-powerline/config.sh".source = ./tmux-powerline.conf.sh;
    ".config/tmux-powerline/themes/custom.sh".source = ./tmux-powerline-theme.sh;
    ".ripgreprc".source = ./ripgreprc;
    ".Xmodmap".source = ./Xmodmap;
  };

  # Set environment variables
  home.sessionVariables = {
    WORKSPACE = "$HOME/workspace";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
  };

  # This value determines the Home Manager release compatibility
  # Don't change unless you know what you're doing
  home.stateVersion = "24.05";
}
