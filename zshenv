# .zshenv is always sourced.
# Most ${ENV_VAR} variables should be saved here.
# It is loaded before .zshrc

#export ZDOTDIR=$HOME/.config/zsh

export XDG_CONFIG_HOME=$HOME/.config/

export fpath=(~/.config/zsh/completions/ $fpath)

[ -d $HOME/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -d $HOME/.luarocks/bin ] && export PATH=$PATH:$HOME/.luarocks/bin
[ -f $HOME/.config/shell/aliases ] && source $HOME/.config/shell/aliases
[ -f $HOME/.shell/kubectl_aliases ] && source $HOME/.shell/kubectl_aliases
[ -f $HOME/.config/shell/funcs ] && source $HOME/.config/shell/funcs

export LF_ICONS="\
di=� :\
fi=�:\
ln=:\
or=:\
ex=:\
*.vimrc=:\
*.viminfo=:\
*.gitignore=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.pdf=:\
*.nix=:\
"

# if [[ $s(command -v rg) ]]; then
#     export FZF_DEFAULT_COMMAND='rg --hidden --ignore .git -g ""'
# fi


# Determine if we are an SSH connection
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    export IS_SSH=true
else
    case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) IS_SSH=true
    esac
fi
