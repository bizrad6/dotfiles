#!/usr/bin/env bash
# =============================================================================
# Dotfiles install script — run automatically by Coder on workspace start.
# Also safe to run manually: bash install.sh
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log()  { echo "[dotfiles] $*"; }
warn() { echo "[dotfiles] WARN: $*" >&2; }

# ---------------------------------------------------------------------------
# Symlink helper — backs up any existing file before linking.
# Usage: link_file <source-relative-to-dotfiles> <destination>
# ---------------------------------------------------------------------------
link_file() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    warn "source not found, skipping: $src"
    return
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    log "already linked: $dst"
    return
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    log "backed up existing $dst → $BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  log "linked: $dst → $src"
}

# ---------------------------------------------------------------------------
# Shell config
# ---------------------------------------------------------------------------
link_file "shell/zshrc"    "$HOME/.zshrc"
link_file "shell/bashrc"   "$HOME/.bashrc"
link_file "shell/aliases"  "$HOME/.aliases"
link_file "shell/exports"  "$HOME/.exports"

# ---------------------------------------------------------------------------
# Git config
# ---------------------------------------------------------------------------
link_file "git/gitconfig"  "$HOME/.gitconfig"
link_file "git/gitignore"  "$HOME/.gitignore_global"

# ---------------------------------------------------------------------------
# Editor / tooling
# ---------------------------------------------------------------------------
link_file "editor/vimrc"   "$HOME/.vimrc"
link_file "editor/tmux.conf" "$HOME/.tmux.conf"

# ---------------------------------------------------------------------------
# Default shell — set to bash if not already
# ---------------------------------------------------------------------------
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "/bin/bash" ]]; then
  if command -v chsh &>/dev/null && grep -q '/bin/bash' /etc/shells; then
    chsh -s /bin/bash
    log "default shell changed to /bin/bash (takes effect on next login)"
  else
    warn "could not set default shell to bash — chsh unavailable or bash not in /etc/shells"
  fi
else
  log "default shell already bash"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
log "install complete."
if [[ -d "$BACKUP_DIR" ]]; then
  log "backups saved to $BACKUP_DIR"
fi
