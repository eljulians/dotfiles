# Dotfiles

My dotfiles: zshrc, aliases, functions, gitconfig, tmux.conf, ripgreprc, p10k.zsh, and more.

Uses [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager) for declarative, cross-distro package management and dotfile symlinking.

Vim is managed separately by [vimrc](https://github.com/eljulians/vimrc).

## Prerequisites

### 1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Restart your terminal (or `source /etc/profile`).

### 2. Install Home Manager

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Installation

```bash
git clone <this-repo> ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh
```

The install script is idempotent - safe to run multiple times.

What it does:
1. Installs packages via Home Manager (ripgrep, fzf, bat, tmux, git, etc.)
2. Symlinks all dotfiles to `$HOME` via Home Manager
3. Installs [oh-my-zsh](https://ohmyz.sh/) if not present
4. Clones/updates the zsh theme and plugins
5. Installs fonts for powerlevel10k
6. Installs TPM (tmux plugin manager)

## Adding/Removing Tools

Edit `home.nix` and add/remove packages from `home.packages`, then run:

```bash
home-manager switch
```

## Zsh setup

**Theme:** [powerlevel10k](https://github.com/romkatv/powerlevel10k)

Dependencies (installed by `scripts/_fonts.sh`):
- [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts) font - required for icons/glyphs

**Terminal font:** Inconsolata Nerd Font (installed via Home Manager)

Config: `~/.p10k.zsh` (run `p10k configure` to regenerate)

**Plugins (third-party, cloned by install.sh):**
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)
- [zsh-bat](https://github.com/fdellwing/zsh-bat)

**Plugins (built-in to oh-my-zsh):**
- git
- kubectl
- aws

## Making changes

**Edit a dotfile (aliases, functions, zshrc, etc.):**
1. Edit the file in this repo (the symlink points here)
2. Commit and push
3. On other machines: `git pull`

**Change powerlevel10k prompt:**
1. Run `p10k configure`
2. This overwrites `~/.p10k.zsh` (symlinked to this repo)
3. Commit and push if you want to keep the changes

**Add a new zsh plugin:**
1. Add the `clone_or_pull` line to `scripts/_zsh-plugins.sh`
2. Add the plugin name to the `plugins=()` array in `zshrc`
3. Run `./install.sh` to install it

## Tmux

[TPM](https://github.com/tmux-plugins/tpm) (plugin manager) is installed by `scripts/_tmux.sh`.

After install, start tmux and press `prefix + I` to install the plugins.

**Plugins:**
- [tpm](https://github.com/tmux-plugins/tpm): plugin manager
- [tmux-powerline](https://github.com/erikw/tmux-powerline): status bar with segments
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank): system clipboard
- [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load): memory/cpu display
- [tmux-fingers](https://github.com/Morantron/tmux-fingers): copy with hints
- [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight): prefix key indicator
- [tmux-urlview](https://github.com/tmux-plugins/tmux-urlview): quick URL open (depends on `urlview`)

**Powerline customization:**
- `tmux-powerline.conf.sh` - segment settings (colors, symbols, API configs)
- `tmux-powerline-theme.sh` - which segments to show and their order

After editing, run `home-manager switch` and restart tmux.

## Secrets

Some features require API keys. These are stored in `secrets.sh` which is gitignored.

To set up:
```bash
cp secrets.sh.example secrets.sh
# Edit secrets.sh with your values
```

Currently used for:
- **Air quality segment**: [OpenWeather API key](https://openweathermap.org/api) (free) + your lat/lon
