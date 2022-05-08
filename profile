
command -v go >/dev/null 2>&1 && export GOPATH=$HOME/.local/share/go && export PATH=$PATH:$(go env GOPATH)/bin

export TERMINAL=alacritty

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

export LANG='en_US.UTF-8'

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -w -X -z-4 -#3 -N'

# Find lesspipe
if command -v lesspipe.sh >/dev/null 2>&1; then
    lesspipe="lesspipe.sh"
elif command -v lesspipe >/dev/null 2>&1; then
    lesspipe="lesspipe"
fi

# Set the less input preprocessor.
if [[ -z "$lesspipe" ]]; then
  export LESSOPEN="| $lesspipe %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# macons only
if [[ "$OSTYPE" =~ "darwin" ]]; then
  export BROWSER="open -a firefox"
  export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
fi

export EXCLUDE_STRING=.git,node_modules/*,**/.git/*,.git/*,target/*,.idea/*,.vscode/*,.terraform/*,.gem/*,.cache,**/cache/*,**go/pkg/*

# linux only
if [[ "$OSTYPE" =~ "linux" ]]; then
  export TERM=screen-256color
  export TERMINAL=alacritty
  export BROWSER=firefox
  export BROWSERCLI=lynx
  export MAIL=/usr/bin/neomutt
  # Apps and Paths
  export QT_QPA_PLATFORMTHEME="qt5ct"
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
  command -v paru >/dev/null 2>&1 && export AUR_MANAGER=paru
  command -v rustc >/dev/null 2>&1 && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src" && export PATH=$PATH:~/.cargo/bin
  # i3wm SSH keys
  if [ "$0" = "/etc/lightdm/Xsession" -a "$DESKTOP_SESSION" = "i3" ]; then
    export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
  fi
  # basedir defaults, in case they're not already set up.
  # http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
  if [[ -z "$XDG_DATA_HOME" ]]; then
    export XDG_DATA_HOME="$HOME/.local/share"
  fi

  if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
  fi

  if [[ -z "$XDG_CACHE_HOME" ]]; then
    export XDG_CACHE_HOME="$HOME/.cache"
  fi

  if [[ -z "$XDG_DATA_DIRS" ]]; then
    export XDG_DATA_DIRS="/usr/local/share:/usr/share"
  fi

  if [[ -z "$XDG_CONFIG_DIRS" ]]; then
    export XDG_CONFIG_DIRS="/etc/xdg"
  else
    export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
  fi
fi

# vim: ft=sh
