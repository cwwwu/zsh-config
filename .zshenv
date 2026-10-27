# Centralize config/cache/data locations
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"

# GPG
export GPG_TTY=$(tty)

# Path - include personal binaries and scripts
export PATH="$HOME/.local/bin:$PATH"

if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
fi

export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
