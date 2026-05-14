# Dotfiles

Personal dotfiles for [Coder](https://coder.com) workspaces (and any Linux/macOS machine).

## Structure

```
dotfiles/
├── install.sh          # Entry point — run by Coder automatically, or manually
├── shell/
│   ├── zshrc           # ~/.zshrc
│   ├── bashrc          # ~/.bashrc
│   ├── aliases         # ~/.aliases  (sourced by both shells)
│   └── exports         # ~/.exports  (env vars, sourced by both shells)
├── git/
│   ├── gitconfig       # ~/.gitconfig
│   └── gitignore       # ~/.gitignore_global
└── editor/
    ├── vimrc           # ~/.vimrc
    └── tmux.conf       # ~/.tmux.conf
```

## How it works

`install.sh` creates symlinks from `$HOME` into this repo. Existing files are
backed up to `~/.dotfiles_backup/<timestamp>/` before being replaced.

## Usage

### In a Coder workspace

Add this repo to your Coder account under **Account → Dotfiles** (or via the
Coder CLI with `coder dotfiles <repo-url>`). Coder will run `install.sh`
automatically on every workspace start.

### Manually

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## Machine-local overrides

These files are sourced automatically but **not** tracked in this repo —
create them locally for machine-specific config:

| File | Purpose |
|---|---|
| `~/.zshrc.local` | Extra zsh config |
| `~/.bashrc.local` | Extra bash config |
| `~/.gitconfig.local` | Git user name/email, signing key, etc. |

## Customisation tips

- **Git identity**: create `~/.gitconfig.local` with your `[user]` block.
- **Node/Python/Go**: uncomment the relevant lines in `shell/exports`.
- **Extra aliases**: add to `shell/aliases` or put one-offs in `~/.zshrc.local`.
