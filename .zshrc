export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Shell behaviour
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT # sort file10 after file 9, not after file1

# Smart directory navigation
eval "$(zoxide init zsh)"


# Completion

# Load completion system
autoload -Uz compinit

# Move .zcompdump cache out of $ZDOTDIR/.zcompdump to $HOME/.cache/zsh
compdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$compdump_dir"
compinit -d "$compdump_dir/zcompdump-${ZSH_VERSION}"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


# Fuzzy finder
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh 
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/prompt.zsh"
