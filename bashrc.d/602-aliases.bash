if $_islinux; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

alias utc='env TZ="UTC" date'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias h="history"

if $_islinux; then
    alias um='udiskie-mount -r'
    alias uu='udiskie-umount'
fi

# tmux
if _have tmux; then
    alias t='tmux attach || tmux'
    alias txl='tmux ls'
    alias txn='tmux new -s'
    alias txa='tmux a -t'
fi

# only if we have mpc
if _have mpc; then
    alias addall='mpc --no-status clear && mpc listall | mpc --no-status add && mpc play'
    alias n='mpc next'
    alias p='mpc prev'
fi

if _have youtube-dl; then
    alias ytwlexp='youtube-dl --download-archive /mnt/SuperBig/Media/Video/YouTube/archive.txt --no-mtime --write-sub --sub-lang en_US --mark-watched --embed-subs -o "/mnt/SuperBig/Media/Video/YouTube/%(uploader)s-%(title)s.%(ext)s" "https://www.youtube.com/playlist?list=PL5D8rBmak6B01Db6kNoGC7oNwL-nRoOFk"'
    alias ytwl='youtube-dl --no-mtime --write-sub --sub-lang en_US --mark-watched --embed-subs -o "/mnt/SuperBig/Media/Video/YouTube/%(uploader)s-%(title)s.%(ext)s" --cookies=~/videos/cookies.txt :ytwatchlater'
    alias yt="youtube-dl --add-metadata -i"
    alias YT="youtube-viewer"
    alias podcast='youtube-dl --no-mtime --verbose -x --audio-format mp3 --audio-quality 0 -o "/mnt/SuperBig/Media/Audio/podcast/%(uploader)s-%(upload_date)s-%(title)s.%(ext)s" https://www.youtube.com/playlist?list=PL5D8rBmak6B39tevwhz_LMTrEof7MeyQt'
  alias yta="yt -x -f bestaudio/best"
fi

if _have rtorrent; then
    alias rtunlock="rm -f /mnt/SuperBig/Downloads/torrents/session/rtorrent.lock"
fi

# emacs
alias em='emacs'
alias en='emacs -nw'
alias et='emacsclient -t'
alias ed='emacs --daemon'
alias ec='emacsclient -c -a emacs'
function ekill() { emacsclient -e '(kill-emacs)';}

# vim
alias e='nvim'
alias E='sudo e'
alias f='e `fzf -i`'

if _have git; then
    alias gc="git commit -v"
    # Not currently working
    #alias gc=". ${HOME}/bin/gitdate && git commit -v "
    alias g="git"
    alias gaa="git aa"
    alias gd="git d"
    alias gdi="git di"
fi

if _have vagrant; then
    #vagrant
    alias vup="vagrant up"
    alias vh="vagrant halt"
    alias vs="vagrant suspend"
    alias vr="vagrant resume"
    alias vrl="vagrant reload"
    alias vssh="vagrant ssh"
    alias vst="vagrant status"
    alias vp="vagrant provision"
    alias vdstr="vagrant destroy"
    # requires vagrant-list plugin
    alias vl="vagrant list"
    # requires vagrant-hostmanager plugin
    alias vhst="vagrant hostmanager"
fi

# setup intellij idea
if [ -d $HOME/tools/idea ] ; then
    alias idea='$HOME/tools/idea/bin/idea.sh &'
fi

alias vnc='x11vnc -display :0 -forever -noxdamage -usepw -httpdir /usr/share/vnc-java/ -httpport 5800 &'
alias lisp='/usr/bin/sbcl'

#update dotfiles
if [ -d "$HOME/.dotfiles" ]; then
    alias ud='cd $HOME/.dotfiles && git pull origin master && rcup -v -x README.md && cd -'
fi

alias usage="du -skc * | sort -rn | more" #lists the sizes in blocks of all your files and sorts them in size order
alias total="du -ch | grep total" #find total size of directory and subdirectories
alias lsDir='ls -d */' #lisitng directories only
alias again="vim `ls -t | head -1`"
alias fixdirs="find . -type d -exec chmod o-rwx {} \;"
alias fixvideo="sudo chown -R dnewman:sambashare /mnt/SuperBig/Media/"
alias prev='ls -t | head -l'
alias findbig="find . -type f -exec ls -s {} \; | sort -n -r | head -5"
# safety features
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias tp="fzf --preview 'bat --color \"always\" {}'"
alias untar='tar xvf'


alias rm30='find * -mtime +30 -exec rm {} \;' # remove files older than 30 days
alias r="ranger"
alias sr="sudo ranger"
alias ka="killall"
alias bc='bc -l' # start calculator with math support
alias sha1='openssl sha1' # generate sha1 digest
alias ports='netstat -tulanp' # show open ports
alias mkdir='mkdir -pv'
alias tree='tree -L 2 -d -l'
alias tree2="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias ccat="highlight --out-format=ansi" # Color cat - print file
alias c='clear'
alias h='history'
alias j='jobs -l'
alias nowtime='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias fastping='ping -c 100 -s .2'
if _have prettyping; then
    alias ping='prettyping --nolegend'
fi
alias ducks="du -sch .i[!.]* * |sort -rh |head -10" # print top 10 largest files in pwd
alias sps="ps aux | grep -v grep | grep"    # search and display processes by keyword
alias df='df -h'
if $_islinux; then
    alias grep='grep --color=auto'
fi
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias myip='printf "%s\n" "$(curl --silent http://tnx.nl/ip)"'
alias reload='exec bash'
alias ruler="echo .........1.........2.........3.........4.........5.........6.........7.........8"
alias psm="echo '%CPU %MEM   PID COMMAND' && ps hgaxo %cpu,%mem,pid,comm | sort -nrk1 | head -n 10 | sed -e 's/-bin//' | sed -e 's/-media-play//'"
alias blankcd="wodim -v dev=/dev/cdrw -blank=fast -eject"
alias count_files_recursive='find . -type f -print | wc -l'
alias count_files_recursive_per_directory='ls -d */ | xargs -I _ sh -c "find \"_\" -type f | wc -l | xargs echo _"'
alias flat_this_dir="sudo find . -mindepth 2 -type f -exec mv -i '{}' . ';'"
alias size_of_directory="ncdu --color dark -rr -x"
alias available_commands='bash -c "compgen -c"'


# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_ed25519.pub | xclip -selection clipboard | echo '=> Public key copied to pasteboard.'"

# Pipe my private key to my clipboard.
alias prikey="more ~/.ssh/id_ed25519 | xclip -selection clipboard | echo '=> Private key copied to pasteboard.'"

# setup dual-montiors when plugged in
alias dual='xrandr --output LVDS-0 --auto --output HDMI-0 --auto --right-of LVDS-0'

if _have colortail; then
    alias tailirc='/usr/bin/colortail -q -k /etc/colortail/conf.irc'
    alias colortail='colortail -q -k /etc/colortail/conf.messages'
fi

# only if we have a disc drive
if [[ -b '/dev/sr0' ]]; then
    alias eject='eject -T /dev/sr0'
    alias mountdvd='sudo mount -t iso9660 -o ro /dev/sr0 /media/dvd/'
    alias backupdvd='dvdbackup -M -i /dev/sr0 -o ~/ripped/'
fi

# mount an iso
function mountiso() { sudo mount -t iso9660 -o loop "$@" /media/iso ;}

alias sdn="sudo shutdown now"
alias psref="gpg-connect-agent RELOADAGENT /bye" # Refresh gpg

# root aliases
if ! $_isroot; then
    alias svim='sudo vim'
    alias reboot='sudo reboot'
    alias shutdown='sudo shutdown -hP now'
    alias scat='sudo cat'
    alias root='sudo su'
    alias windows='sudo grub-set-default 3 && sudo reboot'
    alias bb="sudo bleachbit --clean system.cache system.localizations system.trash system.tmp"
fi

# ubuntu aliases
if $_isubuntu; then
    if ! $_isroot; then
        alias upgrade='sudo apt-get update && sudo apt-get upgrade -y'
        alias apt='sudo apt'
    fi
fi
alias SS="sudo systemctl"

# pacman aliases
if $_isarch; then
    if ! $_isroot; then
        _have pacman-color && alias pacman='sudo pacman-color' || alias pacman='sudo pacman'
        _have powerpill && alias powerpill='sudo powerpill'
    else
        _have pacman-color && alias pacman='pacman-color'
    fi
    _have yay && alias y='yay'
    alias p="sudo pacman"
    alias pacorphans='pacman -Rs $(pacman -Qtdq)'
    alias paccorrupt='sudo find /var/cache/pacman/pkg -name '\''*.part.*'\''' # sudo so we can quickly add -delete
    alias pactesting='pacman -Q $(pacman -Sql {community-,multilib-,}testing) 2>/dev/null'
    alias remove='sudo pacman -Rsc'
    alias pacin='pacman -S'
    alias pacout='pacman -R'
    alias pacsearch='pacman -Ss'
    alias pacup='pacup.rb && sudo pacman -Suy'
    alias upp='sudo reflector -l 20 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syyu && cd /etc/ && sudo etckeeper commit "Auto Commit"; cd -'
    # Pacman alias examples
    alias pacupg='sudo pacman -Syu'		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
    alias pacdl='pacman -Sw'		# Download specified package(s) as .tar.xz ball
    alias pacin='sudo pacman -S'		# Install specific package(s) from the repositories
    alias pacins='sudo pacman -U'		# Install specific package not from the repositories but from a file
    alias pacre='sudo pacman -R'		# Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias pacrem='sudo pacman -Rns'     	# Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias pacrep='pacman -Si'		# Display information about a given package in the repositories
    alias pacreps='pacman -Ss'		# Search for package(s) in the repositories
    alias pacloc='pacman -Qi'		# Display information about a given package in the local database
    alias paclocs='pacman -Qs'		# Search for package(s) in the local database
    alias paclo="pacman -Qdt"		# List all packages which are orphaned
    alias pacc="sudo pacman -Scc"		# Clean cache - delete all the package files in the cache
    alias paclf="pacman -Ql"		# List all files installed by a given package
    alias pacown="pacman -Qo"		# Show package(s) owning the specified file(s)
    alias pacexpl="pacman -D --asexp"	# Mark one or more installed packages as explicitly installed
    alias pacimpl="pacman -D --asdep"	# Mark one or more installed packages as non explicitly installed

    # Additional pacman alias examples
    alias pacupd='sudo pacman -Sy && sudo abs'         # Update and refresh the local package and ABS databases against repositories
    alias pacinsd='sudo pacman -S --asdeps'            # Install given package(s) as dependencies
    alias pacmir='sudo pacman -Syy'                    # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

    # dealing with the following message from pacman:
    #
    #     error: couldnt lock database: file exists
    #     if you are sure a package manager is not already running, you can remove /var/lib/pacman/db.lck

    alias pacunlock="sudo rm /var/lib/pacman/db.lck"   # Delete the lock file /var/lib/pacman/db.lck
    alias paclock="sudo touch /var/lib/pacman/db.lck"  # Create the lock file /var/lib/pacman/db.lck

    # Show directory not owned by any package
    alias pacman-disowned-dirs="comm -23 <(sudo find / \( -path '/dev' -o -path '/sys' -o -path '/run' -o -path '/tmp' -o -path '/mnt' -o -path '/srv' -o -path '/proc' -o -path '/boot' -o -path '/home' -o -path '/root' -o -path '/media' -o -path '/var/lib/pacman' -o -path '/var/cache/pacman' \) -prune -o -type d -print | sed 's/\([^/]\)$/\1\//' | sort -u) <(pacman -Qlq | sort -u)"

    # Show files not owned by any packages
    alias pacman-disowned-files="comm -23 <(sudo find / \( -path '/dev' -o -path '/sys' -o -path '/run' -o -path '/tmp' -o -path '/mnt' -o -path '/srv' -o -path '/proc' -o -path '/boot' -o -path '/home' -o -path '/root' -o -path '/media' -o -path '/var/lib/pacman' -o -path '/var/cache/pacman' \) -prune -o -type f -print | sort -u) <(pacman -Qlq | sort -u)"

    alias lsp="pacman -Qett --color=always | less"

fi

# iptables
alias ipt='sudo /sbin/iptables'

# display all rules
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# Debugging web servers
# get web server headers
alias header='curl -I'

# find out if remote server supports gzip or mod_deflate
alias headerc='curl -I --compress'

# get computer stats asap
alias meminfo='free -m -l -t'

#get top processes eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

#get top processes eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

#get cpu info
alias cpuinfo='lscpu'

#get GPU ram
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# resume wget downloads by default
alias wget='wget -c'

alias top='atop'

# Common Hadoop File System Aliases
if _have hadoop; then
    alias hf="hadoop fs"                                         # Base Hadoop fs command
    alias hfcat="hf -cat"                                        # Output a file to standard out
    alias hfchgrp="hf -chgrp"                                    # Change group association of files
    alias hfchmod="hf -chmod"                                    # Change permissions
    alias hfchown="hf -chown"                                    # Change ownership
    alias hfcfl="hf -copyFromLocal"                              # Copy a local file reference to HDFS
    alias hfctl="hf -copyToLocal"                                # Copy a HDFS file reference to local
    alias hfcp="hf -cp"                                          # Copy files from source to destination
    alias hfdu="hf -du"                                          # Display aggregate length of files
    alias hfdus="hf -dus"                                        # Display a summary of file lengths
    alias hfget="hf -get"                                        # Get a file from hadoop to local
    alias hfgetm="hf -getmerge"                                  # Get files from hadoop to a local file
    alias hfls="hf -ls"                                          # List files
    alias hfll="hf -lsr"                                         # List files recursivly
    alias hfmkdir="hf -mkdir"                                    # Make a directory
    alias hfmv="hf -mv"                                          # Move a file
    alias hfput="hf -put"                                        # Put a file from local to hadoop
    alias hfrm="hf -rm"                                          # Remove a file
    alias hfrmr="hf -rmr"                                        # Remove a file recursivly
    alias hfsr="hf -setrep"                                      # Set the replication factor of a file
    alias hfstat="hf -stat"                                      # Returns the stat information on the path
    alias hftail="hf -tail"                                      # Tail a file
    alias hftest="hf -test"                                      # Run a series of file tests. See options
    alias hftouch="hf -touchz"                                   # Create a file of zero length

    # Convenient Hadoop File System Aliases
    alias hfet="hf -rmr .Trash"                                  # Remove/Empty the trash
    function hfdub() {                                           # Display aggregate size of files descending
        hadoop fs -du "$@" | sort -k 1 -n -r
    }

    #Common Hadoop Job Commands
    alias hj="hadoop job"                                        # Base Hadoop job command
    alias hjstat="hj -status"                                    # Print completion percentage and all job counters
    alias hjkill="hj -kill"                                      # Kills the job
    alias hjhist="hj -history"                                   # Prints job details, failed and killed tip details
    alias hjlist="hj -list"                                      # List jobs

    #Common Hadoop DFS Admin Commands
    alias habal="hadoop balancer"                                # Runs a cluster balancing utility
    alias harep="hadoop dfsadmin -report"                        # Print the hdfs admin report
fi

#Common Oozie Aliases/Functions
if _have oozie; then
    alias owv="oozie validate"                                   # Validate a workflow xml
    alias ojrun="oozie job -run"                                 # Run a job
    alias ojresume="oozie job -resume"                           # Resume a job
    alias ojrerun="oozie job -rerun"                             # Rerun a job
    alias ojsuspend="oozie job -suspend"                         # Suspend a job
    alias ojkill="oozie job -kill"                               # Kill a job
    alias ojinfo="oozie job -info"                               # Display current info on a job
    alias ojlist="oozie jobs -localtime"                         # Display a list of jobs
    alias ojlistr="oozie jobs -localtime -filter status=RUNNING" # Display a list of running jobs
fi

# Enable aliases to be sudo'ed
alias sudo='sudo '

if $_ismac; then
    alias grep='ggrep --color=auto'
    alias out="outdated_apps"
    alias up="update_apps"

    # Brew
    alias brwe="brew"
    alias bs="brew services"
    alias bsl="brew services list"
    alias bss="brew services start"
    alias bssp="brew services stop"
    alias bsr="brew services restart"
    alias bsspa="brew services stop --all"
    alias bi="brew_install"
    alias bu="brew_uninstall"
    alias bci="brew_cask_install"
    alias bcu="brew_cask_uninstall"
    alias i.='(idea $PWD &>/dev/null &)'
    alias o.='open .'
fi

alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
alias c="tr -d '\\n' | xclip -selection clipboard"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen???s ProTip???s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	# shellcheck disable=SC2139,SC2140
	alias "$method"="lwp-request -m \"$method\""
done

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# vhosts
alias hosts='sudo vim /etc/hosts'

# copy working directory
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

#Startup Zalenium docker container
alias startz='docker run --rm -ti --name zalenium -p 4444:4444 -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/videos:/home/seluser/videos --privileged dosel/zalenium start --screenWidth 1920 --screenHeight 1080 --timeZone "America/Chicago"'
#alias startz='docker run --rm -ti --name zalenium -p 4444:4444 -e ZALENIUM_SELENIUM_CONTAINER_MEMORY_LIMIT=8589934592 -e ZALENIUM_SELENIUM_CONTAINER_CPU_LIMIT=400000000 -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/videos:/home/seluser/videos --privileged dosel/zalenium start --screenWidth 1920 --screenHeight 1080 --timeZone "America/Chicago"'
# Kill running Zalenium containers
alias stopz='curl -sSL https://raw.githubusercontent.com/dosel/t/i/p | bash -s stop'

if _have curl; then
    alias cl='curl -L'
    # follow redirects, download as original name
    alias clo='curl -L -O'
    # follow redirects, download as original name, continue
    alias cloc='curl -L -C - -O'
    # follow redirects, download as original name, continue, retry 5 times
    alias clocr='curl -L -C - -O --retry 5'
    # follow redirects, fetch banner
    alias clb='curl -L -I'
    # see only response headers from a get request
    alias clhead='curl -D - -so /dev/null'
fi

#Maven
if _have mvn; then
    alias mci='mvn clean install'
    alias mi='mvn install'
    alias mrprep='mvn release:prepare'
    alias mrperf='mvn release:perform'
    alias mrrb='mvn release:rollback'
    alias mdep='mvn dependency:tree'
    alias mpom='mvn help:effective-pom'
    alias mcisk='mci -Dmaven.test.skip=true'
fi

#NordVPN
alias nord='sudo openvpn ~/Dropbox/nordvpn/us1967.nordvpn.com.udp1194.ovpn'

# Composer
if [ -f ~/bin/composer.phar ]; then
    alias composer='php ~/bin/composer.phar'
fi

# broot
alias br='br -dhp'
alias bs='br --sizes'

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# termbin
alias tb="nc termbin.com 9999"

# Change terminal colors
alias termcolor="alacritty-colorscheme -t gruvbox_light.yaml gruvbox_dark.yaml"

