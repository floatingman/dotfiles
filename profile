# set platform name so that we can run scripts based on the OS
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  if [[ -d "/run/WSL" ]]; then
    platform_wsl='true'
  elif grep -q microsoft /proc/version; then
    platform_wsl='true'
  else
    platform_wsl='false'
  fi
elif [[ "$unamestr" == 'Darwin' ]]; then
  # shellcheck disable=SC2034
  platform='macos'
  # shellcheck disable=SC2034
  platform_wsl='false'
  if [[ `uname -m` == 'arm64' ]]; then
    platform_apple_silicon='true'
  fi
fi
unset unamestr

export TERMINAL=alacritty

#
# Editors
#

export EDITOR='nvim'
export VISUAL='nvim'
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

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


export EXCLUDE_STRING=.git,node_modules/*,**/.git/*,.git/*,target/*,.idea/*,.vscode/*,.terraform/*,.gem/*,.cache,**/cache/*,**go/pkg/*

# Notes
#

# Set the default note directory.
export NOTEDIR=~/library/notes

# Open spreadsheet notes in visidata
export NOTEXDGEXT="csv tsv"

#
# Journal
#

# Set the default journal directory.
export JOURNALDIR=~/library/journal

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
  # if [ "$0" = "/etc/lightdm/Xsession" -a "$DESKTOP_SESSION" = "i3" ]; then
  #   export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
  # fi
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

eval $(keychain --eval --quiet --noask --agents ssh,gpg id_ed25519_dlp id_ed25519_suse id_ed25519_suse_nopw dnewman-suse-nopw F30B951D85DBE1C0)

# This is the list for lf icons:
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.wav=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.avi=🎥:\
*.mov=🎥:\
*.mpg=🎥:\
*.wmv=🎥:\
*.m4b=🎥:\
*.flv=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
"
# vim: ft=sh
