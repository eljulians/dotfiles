{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.packages = with pkgs; [
    # Shell essentials
    ripgrep
    fzf
    bat
    fd
    eza
    zoxide
    atuin
    tmux
    xclip

    # Git
    git
    gh
    delta

    # Dev tools
    jq
    htop
    btop
    dust
    duf
    procs
    yazi
    tldr
    hyperfine
    curl
    wget
    bc
    unimatrix
    noto-fonts-cjk-sans
    pulumi

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

    # JavaScript (for npm-based tools like ccstatusline)
    nodejs

    # Python
    python3

    # Container tools
    docker
    docker-compose
    lazydocker
    kubectl

    # Kubernetes
    k9s
    kubectx
    stern

    # Data/API
    yq-go
    xh
    jless

    # Terminal utilities
    viddy
    difftastic
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
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/ccstatusline/settings.json" = {
      source = pkgs.replaceVars ./ccstatusline.json {
        HOME = config.home.homeDirectory;
      };
      force = true;
    };
    ".local/bin/git-damage" = { source = ./bin/git-damage; executable = true; };
    ".local/bin/moonphase" = { source = ./bin/moonphase; executable = true; };
    ".local/bin/kaomoji" = { source = ./bin/kaomoji; executable = true; };
    ".claude/settings.json" = {
      source = pkgs.replaceVars ./claude-settings.json {
        HOME = config.home.homeDirectory;
      };
      force = true;
    };
    ".claude/CLAUDE.md" = {
      source = ./ai/claude/CLAUDE.md;
      force = true;
    };
    ".claude/RTK.md" = {
      source = ./ai/claude/RTK.md;
      force = true;
    };
    ".claude/hooks/rtk-rewrite.sh" = {
      source = ./ai/claude/hooks/rtk-rewrite.sh;
      executable = true;
      force = true;
    };
    ".codex/AGENTS.md" = {
      source = ./ai/codex/AGENTS.md;
      force = true;
    };
    ".codex/config.template.toml" = {
      source = pkgs.replaceVars ./ai/codex/config.toml {
        HOME = config.home.homeDirectory;
      };
      force = true;
    };
    ".codex/deep-review.config.toml" = {
      source = ./ai/codex/deep-review.config.toml;
      force = true;
    };
    ".codex/full-send.config.toml" = {
      source = ./ai/codex/full-send.config.toml;
      force = true;
    };
    ".codex/RTK.md" = {
      source = ./ai/codex/RTK.md;
      force = true;
    };
    ".codex/hooks/rtk-rewrite.sh" = {
      source = ./ai/codex/hooks/rtk-rewrite.sh;
      executable = true;
      force = true;
    };
    ".codex/hooks/turn-done.sh" = {
      source = ./ai/codex/hooks/turn-done.sh;
      executable = true;
      force = true;
    };
  };

  home.activation.codexWritableConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
    codex_dir="$HOME/.codex"
    target="$codex_dir/config.toml"
    template="$codex_dir/config.template.toml"

    mkdir -p "$codex_dir" "$codex_dir/worktrees"

    if [ ! -e "$target" ] || [ -L "$target" ]; then
      if [ -e "$target" ] && [ ! -e "$target.pre-home-manager" ]; then
        cp --dereference "$target" "$target.pre-home-manager"
      fi
      rm -f "$target"
      cp "$template" "$target"
      chmod u+w "$target"
    fi
  '';

  # Add directories to PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

  # Set environment variables
  home.sessionVariables = {
    WORKSPACE = "$HOME/workspace";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Auto-update npm-based and external CLI tools on home-manager switch
  home.activation.updateExternalTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="${pkgs.nodejs}/bin:${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"
    mkdir -p "$HOME/.npm-global"
    npm install -g @anthropic-ai/claude-code@latest || echo "WARNING: claude-code npm install failed"
    npm install -g @google/gemini-cli@latest || echo "WARNING: gemini-cli npm install failed"
    npm install -g ccstatusline@latest || echo "WARNING: ccstatusline npm install failed"
    npm install -g @openai/codex || echo "WARNING: codex npm install failed"
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh || echo "WARNING: rtk install failed"
  '';

  # This value determines the Home Manager release compatibility
  # Don't change unless you know what you're doing
  home.stateVersion = "24.05";
}
