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

    # Python
    python3

    # Container tools (uncomment if needed)
     docker
     docker-compose
     kubectl
  ];

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
