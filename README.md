# dotfiles

Bare git repo tracking `~/.config/` — 178 files across system configs, editors,
shell tools, window manager, and more.

## Quick start (new machine)

```bash
git clone --bare git@github.com:tuan-cre/.dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME/.config'
dotfiles config status.showUntrackedFiles no
dotfiles checkout
```

## Usage

```bash
dotfiles status          # check what changed
dotfiles add -A          # stage all changes
dotfiles commit -m "..." # commit
dotfiles push            # push to GitHub
dotfiles pull            # pull latest
```

## What's tracked

Notable configs:
- **WM/UI:** hypr, waybar, waywall, fuzzel, foot, nwg-drawer
- **Editors:** nvim, kitty, micro, vlc, kate
- **Shell/tools:** btop, htop, fastfetch, fcitx5, pipewire
- **System:** systemd user services, environment.d, user-dirs
- **Development:** gh, Code/User/settings.json, godot, flutter
- **Other:** obs-studio scenes/profiles, MangoHud, kdeconnect

## What's excluded

Caches, logs, app data (discord/vesktop/Twitch/libreoffice/unityhub),
VS Code internals (extensions, web storage, crash data),
opencode node_modules, GitHub OAuth tokens, runtime sockets,
binary state files, and secrets (*.pem, oauth.json).

## Structure

```
~/.config/         ← worktree (what gets tracked)
~/.dotfiles/       ← bare repo
  └── info/exclude ← patterns for excluded files
```
