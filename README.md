# zsh-config

My personal zsh configuration for macOS. It lives in `~/.config/zsh` (the XDG location) instead of scattering dotfiles across `$HOME`.

## Layout

| File | Purpose |
| --- | --- |
| `.zshenv` | Loaded by every shell. Sets the XDG base dirs, `EDITOR`/`VISUAL`, `GPG_TTY`, `PATH` (`~/.local/bin`), `MANPAGER` (bat) and `STARSHIP_CONFIG`. |
| `.zprofile` | Loaded by login shells. Initializes pyenv. |
| `.zshrc` | Loaded by interactive shells. Sets up history, shell options, zoxide, completion and fzf key bindings, then sources the modules below in order. |
| `fzf.zsh` | fzf defaults (uses `fd` for file listing and `bat` for previews) and a `Ctrl+F` widget that picks files without showing hidden ones. |
| `aliases.zsh` | Aliases: `eza` for `ls`, `bat` for `cat`, `rg` for `grep`, `nvim` for `vim`. Also git log shortcuts, a `dotfiles` bare-repo alias and an `lf` wrapper that `cd`s into the last directory you were in. |
| `bindings.zsh` | zsh-vi-mode cursor and highlight settings. Custom key bindings are registered in `zvm_after_init` so zsh-vi-mode doesn't reset them. |
| `plugins.zsh` | A small plugin loader. Missing plugins are cloned into `plugins/` on first launch, and `zplugin-update` pulls updates for all of them. |
| `prompt.zsh` | Starts the [Starship](https://starship.rs) prompt. |
| `starship.toml` | Starship config: directory, git branch and status, node/rust/go versions, and a vi-mode prompt character. |
| `.githooks/pre-commit` | Secret-scanning hook (see [Secret scanning](#secret-scanning)). |

Some files are created at runtime and are not tracked:

- `plugins/`: cloned automatically by `plugins.zsh`
- history: `$XDG_STATE_HOME/zsh/history` (`~/.local/state/zsh/history`)
- completion dump: `$XDG_CACHE_HOME/zsh/zcompdump-*` (`~/.cache/zsh/`)

### Plugins

Plugins are cloned from GitHub the first time a shell starts:

- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode)
- [zdharma-continuum/fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)

### Key bindings

| Key | Action |
| --- | --- |
| `Ctrl+R` | fzf history search |
| `Ctrl+T` | fzf file picker (includes hidden files) |
| `Ctrl+F` | fzf file picker (excludes hidden files) |
| `Up` / `Down` | History search by substring |
| `Ctrl+Left` / `Ctrl+Right` | Move back or forward one word |
| `Ctrl+\` | Turn autosuggestions on or off |

## Dependencies

Install with [Homebrew](https://brew.sh):

```sh
brew install git starship fzf fd bat eza ripgrep zoxide neovim lf pyenv gitleaks
```

| Tool | Used for |
| --- | --- |
| `git` | Cloning plugins |
| `starship` | Prompt |
| `fzf` | Fuzzy finding (key bindings are loaded from `/opt/homebrew/opt/fzf`) |
| `fd` | File listing for fzf |
| `bat` | `cat` alias, fzf previews and `MANPAGER` |
| `eza` | `ls`, `ll`, `la` and `tree` aliases |
| `ripgrep` | `grep` alias |
| `zoxide` | Smart `cd` (`z`) |
| `neovim` | `EDITOR`/`VISUAL` and the `vim` alias |
| `lf` | Terminal file manager (`lf` wrapper) |
| `pyenv` | Python version management |
| `gitleaks` | Pre-commit secret scanning (only needed for working on this repo) |

You also need a [Nerd Font](https://www.nerdfonts.com) set as your terminal font so the prompt and `eza` icons display correctly.

## Installation

### 1. Clone into `~/.config/zsh`

```sh
git clone git@github.com:cwwwu/zsh-config.git ~/.config/zsh
```

### 2. Point zsh at `~/.config/zsh`

By default zsh reads its startup files (`.zshenv`, `.zprofile`, `.zshrc`, ...) from `$HOME`. If the `ZDOTDIR` variable is set, zsh reads them from that directory instead. The catch is that zsh needs `ZDOTDIR` before it reads any of them. It solves this by always reading `$HOME/.zshenv` first.

So the only file that has to stay in `$HOME` is a two-line `~/.zshenv` that sets `ZDOTDIR` and hands off to this repo:

```sh
cat > ~/.zshenv <<'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
EOF
```

The `source` line is required. zsh has already finished the `.zshenv` step by the time `ZDOTDIR` takes effect, so it never reads `$ZDOTDIR/.zshenv` by itself. The later files (`.zprofile`, `.zshrc`, `.zlogin`) are read from `$ZDOTDIR` automatically.

If you have old config files in `$HOME` (`~/.zshrc`, `~/.zprofile`, `~/.zsh_history`, `~/.zcompdump*`), back them up or remove them so they don't cause confusion. zsh ignores them once `ZDOTDIR` is set.

### 3. Start a new shell

```sh
exec zsh
```

The first launch clones the plugins into `~/.config/zsh/plugins/`. To check that the setup worked:

```sh
echo $ZDOTDIR   # ~/.config/zsh
echo $HISTFILE  # ~/.local/state/zsh/history
```

If history doesn't save, create the state directory with `mkdir -p ~/.local/state/zsh`.

### Updating plugins

```sh
zplugin-update
```

## Secret scanning

This repo has a pre-commit hook in `.githooks/pre-commit`. It runs [gitleaks](https://github.com/gitleaks/gitleaks) on staged changes and blocks the commit if it finds something that looks like an API key, token or private key. If gitleaks isn't installed, the hook blocks every commit, so a missing tool can't let a secret slip through.

Git doesn't enable hooks from a cloned repo automatically. Turn it on once per clone:

```sh
brew install gitleaks
git -C ~/.config/zsh config core.hooksPath .githooks
```

If gitleaks flags a false positive, add `# gitleaks:allow` to the end of that line. Alternatively, add the finding's fingerprint to a `.gitleaksignore` file. `git commit --no-verify` skips the hook entirely; only use it if you are sure.

Keep real secrets out of these files. Load them from the macOS Keychain or from an untracked file instead.
