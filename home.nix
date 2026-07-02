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
    neovim
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
    # NOTE: ~/.claude/settings.json is intentionally NOT managed via home.file.
    # Claude Code writes to it at runtime (e.g. /effort), and a /nix/store
    # symlink would be read-only. See home.activation.seedClaudeSettings below.
  };

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

  # Manage ~/.claude/settings.json as a writable file. Claude Code mutates
  # it at runtime (e.g. /effort), so it can't be a /nix/store symlink.
  # Strategy: jq-merge claude-settings.json INTO the live file on every switch.
  #   - keys declared in claude-settings.json are enforced (dotfiles win)
  #   - keys not declared are preserved (Claude's runtime mutations survive)
  home.activation.seedClaudeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    target="$HOME/.claude/settings.json"
    src=${./claude-settings.json}
    mkdir -p "$HOME/.claude"
    [ -L "$target" ] && rm -f "$target"
    if [ ! -e "$target" ]; then
      install -m 644 "$src" "$target"
    else
      tmp=$(mktemp)
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$src" > "$tmp"
      install -m 644 "$tmp" "$target"
      rm -f "$tmp"
    fi
  '';

  # Auto-update npm-based tools on home-manager switch
  home.activation.updateNpmTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="${pkgs.nodejs}/bin:$PATH"
    mkdir -p "$HOME/.npm-global"
    npm install -g @anthropic-ai/claude-code@latest || echo "WARNING: claude-code npm install failed"
    npm install -g @google/gemini-cli@latest || echo "WARNING: gemini-cli npm install failed"
    npm install -g ccstatusline@latest || echo "WARNING: ccstatusline npm install failed"
  '';

  # This value determines the Home Manager release compatibility
  # Don't change unless you know what you're doing
  home.stateVersion = "24.05";
}
