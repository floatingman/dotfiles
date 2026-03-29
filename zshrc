# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/dnewman/.zsh/completions:"* ]]; then export FPATH="/home/dnewman/.zsh/completions:$FPATH"; fi
# Set the shell to zsh
# export SHELL=/bin/zsh

# Something for me to see where aliases get defined
# Use 256 colors
export TERM=xterm-256color
export LANG=en_US.UTF8

## Import locations
export ZSH_CUSTOM=~/.config/zsh/custom/
export ZSH_ENV_HOME=$HOME/

export XDG_CONFIG_HOME=$HOME/.config/

## ZSH options
setopt functionargzero
setopt AUTO_CD              # Go to folder path without using cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
setopt NOCASEGLOB           # Do not use case-insensitive globbing.
setopt RCEXPANDPARAM        # Array expansion with parameters.
setopt NUMERICGLOBSORT      # Sort filenames numerically when it makes sense.
setopt NOBEEP               # Don't beep when an error occurs.

## ZSH environment options

# Load ZSH Options
# all of our zsh files
typeset -U config_files
config_files=($XDG_CONFIG_HOME/zsh/*/*.zsh)


# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

## ZSH plugins
# fpath=($XDG_CONFIG_HOME/zsh/submods/gcloud-zsh-completion/src/ $fpath)

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files

# Setup dotfiles bare repository usuage
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
if [[ $(whence -w __git_complete) == 'function' ]]; then
  __git_complete dotfiles git
fi

export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# source apps
export _ZO_FZF_OPTS="$_FZF_DEFAULT_OPTS --select-1 --exit-0 --height=25% --reverse --no-sort --cycle"
export _ZO_DATA_DIR=$HOME/.zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
compdef __zoxide_z_complete j
command -v direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
[ -d $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br

# load private things if there
[ -f "$HOME/.zsh_private" ] && source "$HOME/.zsh_private"

# load mac things if there
[ -f "$HOME/.zsh_mac" ] && source "$HOME/.zsh_mac"


# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
# bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'                # find file and cd to selected directory

# Enable Ctrl-xe to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line


# ZSH Plugins
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Plugin history-search-multi-word loaded with investigating.
zinit light zdharma-continuum/history-search-multi-word

# forgit for easier gitting
zinit load wfxr/forgit

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit light agkozak/zsh-z
zinit light Aloxaf/fzf-tab

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# . "$HOME/.atuin/bin/env"

# eval "$(atuin init zsh)"

# Added by LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
[[ -d "$HOME/.arkade/" ]] && export PATH=$PATH:$HOME/.arkade/bin

# SSH keychain setup - cache SSH key passphrases
eval $(keychain --eval --agents ssh id_ed25519_dlp id_ed25519_suse)

# opencode
[[ -d "$HOME/.opencode/" ]] && export PATH=/home/dnewman/.opencode/bin:$PATH

# linuxbrew
[[ -d "$HOME/.linuxbrew/" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/opentofu/1.10.6/bin/tofu tofu
# >>> ccm function begin >>>
# CCM: define a shell function that applies exports to current shell
# Ensure no alias/function clashes
unalias ccm 2>/dev/null || true
unset -f ccm 2>/dev/null || true
ccm() {
  local script="/home/dnewman/.local/share/ccm/ccm.sh"
  # Fallback search if the installed script was moved or XDG paths changed
  if [[ ! -f "$script" ]]; then
    local default1="${XDG_DATA_HOME:-$HOME/.local/share}/ccm/ccm.sh"
    local default2="$HOME/.ccm/ccm.sh"
    if [[ -f "$default1" ]]; then
      script="$default1"
    elif [[ -f "$default2" ]]; then
      script="$default2"
    fi
  fi
  if [[ ! -f "$script" ]]; then
    echo "ccm error: script not found at $script" >&2
    return 1
  fi

  # All commands use eval to apply environment variables
  case "$1" in
    ""|"help"|"-h"|"--help"|"status"|"st"|"config"|"cfg"|"save-account"|"switch-account"|"list-accounts"|"delete-account"|"current-account"|"debug-keychain"|"project")
      # These commands don't need eval, execute directly
      "$script" "$@"
      ;;
    *)
      # All other commands (model switching) use eval to set environment variables
      eval "$("$script" "$@")"
      ;;
  esac
}

# CCC: Claude Code Commander - switch model and launch Claude Code
# Ensure no alias/function clashes
unalias ccc 2>/dev/null || true
unset -f ccc 2>/dev/null || true
ccc() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ccc <model> [region|variant] [claude-options]"
    echo "       ccc open <provider> [claude-options]"
    echo "       ccc <account> [claude-options]            # Switch account then launch"
    echo "       ccc <model>:<account> [claude-options]"
    echo ""
    echo "Examples:"
    echo "  ccc deepseek                              # Launch with DeepSeek"
    echo "  ccc open kimi                             # Launch with OpenRouter (kimi)"
    echo "  ccc woohelps                              # Switch to 'woohelps' account and launch"
    echo "  ccc claude:work                           # Switch to 'work' account and use Claude"
    echo "  ccc glm --dangerously-skip-permissions    # Launch GLM with options"
    echo ""
    echo "Available models:"
    echo "  Official: deepseek, glm, kimi, qwen, seed|doubao, claude, minimax"
    echo "  OpenRouter: open <provider>"
    echo "  Account:  <account> | claude:<account>"
    return 1
  fi

  local model=""
  local open_provider=""
  local region_arg=""
  local seed_variant=""

  if [[ "$1" == "open" ]]; then
    shift || true
    if [[ $# -lt 1 ]]; then
      echo "Usage: ccc open <provider> [claude-options]"
      return 1
    fi
    model="open"
    open_provider="$1"
    shift || true
  else
    model="$1"
    shift || true
  fi
  
  # Helper: known model keyword
  _is_known_model() {
    case "$1" in
      deepseek|ds|glm|glm5|kimi|kimi2|qwen|minimax|mm|seed|doubao|claude|sonnet|s|open)
        return 0 ;;
      *)
        return 1 ;;
    esac
  }

  # Configure environment via ccm
  if [[ "$model" != "open" ]] && [[ "$model" != *:* ]] && ! _is_known_model "$model" && [[ ! "$model" =~ ^- ]]; then
    # Treat as account name
    local account="$model"
    echo "🔄 Switching account to $account..."
    ccm switch-account "$account" || return 1
    ccm current-account || true
    ccm claude || return 1
  else
    if [[ "$model" == "open" ]]; then
      echo "🔄 Switching to OpenRouter ($open_provider)..."
      ccm open "$open_provider" || return 1
    else
      case "$model" in
        kimi|kimi2|qwen|glm|glm5|minimax|mm)
          if [[ "${1:-}" =~ ^(global|china|cn)$ ]]; then
            region_arg="$1"
            shift || true
          fi
          ;;
        seed|doubao)
          if [[ "${1:-}" =~ ^(doubao|glm|glm5|deepseek|ds|kimi|kimi2)$ ]]; then
            seed_variant="$1"
            shift || true
          fi
          ;;
      esac

      if [[ -n "$seed_variant" ]]; then
        echo "🔄 Switching to $model ($seed_variant)..."
        ccm "$model" "$seed_variant" || return 1
      elif [[ -n "$region_arg" ]]; then
        echo "🔄 Switching to $model ($region_arg)..."
        ccm "$model" "$region_arg" || return 1
      else
        echo "🔄 Switching to $model..."
        ccm "$model" || return 1
      fi
    fi
  fi

  # Collect additional Claude Code arguments
  local claude_args=("$@")

  echo ""
  echo "🚀 Launching Claude Code..."
  echo "   Model: $ANTHROPIC_MODEL"
  echo "   Base URL: ${ANTHROPIC_BASE_URL:-Default (Anthropic)}"
  echo ""

  # Ensure  CLI exists
  if ! type -p claude >/dev/null 2>&1; then
    echo "❌ 'claude' CLI not found. Install: npm install -g @anthropic-ai/claude-code" >&2
    return 127
  fi

  # Launch Claude Code
  if [[ ${#claude_args[@]} -eq 0 ]]; then
    exec claude
  else
    exec claude "${claude_args[@]}"
  fi
}
# <<< ccm function end <<<

# ByteRover CLI
export PATH="$HOME/.brv-cli/bin:$PATH"
