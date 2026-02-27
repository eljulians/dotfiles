# Dotfiles

My dotfiles: zshrc, aliases, functions, gitconfig, tmux.conf, ripgreprc, p10k.zsh, and more.

## Installation

```bash
git clone <this-repo> ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh
```

The install script is idempotent - safe to run multiple times.

What it does:
1. Installs [oh-my-zsh](https://ohmyz.sh/) if not present
2. Clones/updates the zsh theme and plugins (see below)
3. Symlinks all dotfiles to `$HOME` (e.g., `zshrc` -> `~/.zshrc`)

## Zsh setup

**Theme:** [powerlevel10k](https://github.com/romkatv/powerlevel10k)

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
1. Add the `clone_or_pull` line to `install.sh`
2. Add the plugin name to the `plugins=()` array in `zshrc`
3. Run `./install.sh` to install it

## Tmux plugins

- [tpm](https://github.com/tmux-plugins/tpm): plugin manager
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): persist environment
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum/): continuous saving
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank): system clipboard
- [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load): memory/cpu display
- [tmux-fingers](https://github.com/Morantron/tmux-fingers): copy with hints
- [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight): prefix key indicator
- [tmux-urlview](https://github.com/tmux-plugins/tmux-urlview): quick URL open (depends on `urlview`)
