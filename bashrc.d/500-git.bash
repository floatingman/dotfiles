
####################### Git Repos / GitHub / GitLab ######################

# Even though the git user.name can be different between repos and
# providers it is best to find a username that is consistent across
# providers and has the same git user.email. If not, stick with one
# provider or override.

havecmd git && export GITUSER="$(git config --global user.name)"

# Detect if the current directory is within a git repository (no matter
# how deep into subdirectories.

isgit () {
  git rev-parse >/dev/null >/dev/null 2>&1
  return $?
} && export -f isgit

# Print the git user.name for the current location.

gituser () { git config user.name; } && export -f gituser

# Print the git user.email for the current location.

gitemail () { git config user.email; } && export -f gitemail

# Print the git user. for the current location.

#gitgpg () { git config TODO???;} && export -f gitgpg

# Print the git remote.origin.url for the current location.

giturl () { git config remote.origin.url; } && export -f giturl

#alias gituser='git config user.name'
#alias gitemail='git config user.email'
#alias gitgpg='git config user.email'
#alias giturl='git config user.email'

# TODO write the comment doc extractor and Pandoc renderer (later)

repo () {
  [[ -z "$REPOS" ]] && telln 'Need to set `$REPOS` first.`' && return 1

  declare manifest="$REPOS/MANIFEST"
  declare subcmd="$1"; shift
  declare server repo rok user url pdir ppath entity

  #TODO seriously consider doing this stuff for every repo subcommand
  # instead of just a select few (most do already).

  case "$subcmd" in
    create|clone|forcedelete|gobadges|delete|show|\
      private|public|listremoteother|listremote|fork|\
      gobadges) 

      
      if [[ -n "$1" ]]; then
        url="$1"
      elif repo inpath; then
        url=$(repo current)
      else
        warnln "Not in $REPOS. Cannot infer repo information."
        return 1
      fi

    #TODO be okay with partial urls in order to infer the service
    #TODO add a default service to .gitconfig (so repo clone does not need
    # full remote path, repo listremote and others need default
    # service, could even make it so partial matches are thrown
    # into a select)

    # TODO grab the git user for each call instead of GITUSER

      server="${url%%/*}"
      repo="${url#*/}"
      entity="${repo%/*}"
      pdir=$(dirpart "$repo")
      reponame=$(basepart "$repo")
      ppath="$REPOS/$pdir"
      tok=$(token "$server")
      ;;
  esac

  case "$subcmd" in

    # Discover descends through the entire $REPOS tree finding Git repos
    # by them having .git directories. It take longer than I would want to
    # do on the command line so it is normally called only from `repo
    # mkmanifest` to create the manifest for faster matches.

    discover) 
      declare dirs=("$REPOS/"**/.git)
      declare dir
      for dir in "${dirs[@]}"; do
        dir=${dir%/.git}
        dir=${dir#$REPOS/}
        echo $dir
      done
      ;;

    # Just simple list of the repos in the current manifest cache.

    list) 
      if [[ ! -e "$manifest" ]]; then
        telln 'Manifest missing, do `repo mkmanifest` to create.'
        return 1
      fi
      katlines "$manifest"
      ;; 

    # Generates a freshly cached $REPOS/MANIFEST file for faster searching
    # and listing. (The full find descent it not particularly responsive.)

    mkmanifest)
      declare dirs=$(repo discover)
      echo '# Generated by `repo mkmanifest`'$(now) >| "$manifest"
      echo >> "$manifest"
      echo "$dirs" >> "$REPOS/MANIFEST" 
      ;;

    # Paths are just the long version of list.

    paths)
      declare repos=($(repo list))
      declare r
      for r in "${repos[@]}"; do
        echo "$REPOS/$r"
      done
      ;;

    # Returns urinary true is current directory is within the $REPOS
    # directory.

    inpath) [[ "$PWD" =~ "$REPOS" ]] && return 0; return 1 ;; 

    # Returns the inferred full repo URL if currently anywhere within a
    # $REPOS subdirectory.

    current) 
      if repo inpath; then
        declare cur="$PWD"
        while [[ "$cur" != "$REPOS" ]]; do
          if [[ -d "$cur/.git" ]]; then
          declare relative=${cur#$REPOS/}
            echo $relative
            return
          else
            cur=${cur%/*}
          fi
        done
      fi
      return 1
    ;;

    # If no arguments are passed at all just changes into the $REPOS
    # directory.

    "") [[ -n "$REPOS" ]] && cd "$REPOS" ;;

    # Matches the keyword or regular expression typed in from the list of
    # repos in the current MANIFEST (repo list).

    match)
      repo list | perg "$1"
      ;;

    # Creates a new repo at the specified URL. The repo at that location
    # will be created and the new repo will be cloned to the local system
    # into the $REPOS directory. Current directory is then changed into
    # the newly cloned directory. Only GitHub is currently supported
    # (github.com).

    create)
      if [[ -e "$REPOS/$url" ]];then
        telln 'Already created: `'$url'`'
        return 1
      fi
      if [[ "$server" == github.com ]]; then
        declare type=user
        if [[ ! "$repo" =~ ^$GITUSER ]];then
          type=orgs/$entity
        fi
        declare -i status=$(curl -X POST -H "Authorization: token $tok" \
          -d '{"name":"'"$reponame"'","private":true}' \
          -w "%{http_code}" \
          -s -o /dev/null \
          "https://api.github.com/$type/repos")
        if [[ $status != 201 ]]; then
          telln '***Failed with status:*** `'$status'`'
          return 1
        fi
        repo clone "$url"
        return
      fi
      telln 'Unsupported Git service or server: `'$server'`'
      return 1
      ;;

    # Clones the URL into the $REPOS directory and changes into the new
    # directory. Also update the local $REPOS/MANIFEST (`repo mkmanifest`)
    # to `match` and `list` return correct results.

    clone)
      if [[ -e "$REPOS/$url" ]];then
        telln 'Already cloned: `'$url'`'
        return 1
      fi
      mkdir -p "$ppath" # gitlab allows sub groups/directories
      git clone git@$server:$repo "$REPOS/$url"
      [[ $? != 0 ]] && return 1
      cd "$REPOS/$url"
      echo "$REPOS/$url"
      repo mkmanifest
      ;;

    # Deletes the specified URL from the remote system and local $REPOS
    # directory. When called with no URL attempts to infer the repo of the
    # current working directory and deletes that repo instead changing
    # into the $REPOS directory when completed.

    delete)
      if [[ "$server" == github.com ]]; then
        danger 'Do you really want to delete `'$server/$repo'`?'
        confirm || return
        repo forcedelete "$*"
        return
      fi
      telln 'Unsupported Git service or server: `'$server'`'
      return 1
      ;;

    # Deletes like `repo delete` but without any confirmation.

    forcedelete)
      if [[ "$server" == github.com ]]; then
        curl -X DELETE -H "Authorization: token $tok" \
          "https://api.github.com/repos/$repo"
        if [[ -d "$REPOS/$url" ]]; then
          cd "$REPOS"
          rm -rf "$REPOS/$url"
          repo mkmanifest
        fi
        return
      fi
      telln 'Unsupported Git service or server: `'$server'`'
      return 1
      ;;

    listremote)
      # TODO conditional on service github
      declare buf=$(curl -X GET -H "Authorization: token $tok" \
        "https://api.github.com/users/$GITUSER/repos" --silent)
      while IFS= read -r line; do
        line=${line//\"/}
        line=${line//\,/}
        line=${line##*:}
        echo $line
      done < <(echo "$buf" | perg full_name)
      return
      ;;

    listremoteother)
      declare buf=$(curl -X GET -H "Authorization: token $tok" \
        "https://api.github.com/user/repos" --silent)
      while IFS= read -r line; do
        line=${line//\"/}
        line=${line//\,/}
        line=${line##*:}
        echo $line
      done < <(echo "$buf" | perg full_name)
      return
      ;;

    # Forks the specified repo creating a repo in the user's remote
    # service collection and then clones it down into $REPOS locally (repo
    # clone).

    fork)
      if [[ "$server" == github.com ]]; then
        curl -X POST -H "Authorization: token $tok" -d '' "https://api.github.com/repos/$repo/forks" 
        repo clone "$*"
      fi
      return
      ;;

    private)
      telln 'Would make private'
      ;;

    public)
      curl -X PATCH -H "Authorization: token $tok" -d '{"private":false}' \
        "https://api.github.com/repos/$repo"
        return 
      ;;

    show)
      if [[ "$server" == github.com ]]; then
         curl -X GET -H "Authorization: token $tok" \
         "https://api.github.com/repos/$repo"
        return
      fi
      telln 'Unsupported Git service or server: `'$server'`'
      return 1
    ;;

    gobadges)
      echo "![WIP](https://img.shields.io/badge/status-wip-red)"
      echo "[![GoDoc](https://godoc.org/$url?status.svg)](https://godoc.org/$url)"
      echo "[![Go Report Card](https://goreportcard.com/badge/$url)](https://goreportcard.com/report/$url)"
      echo "[![Coverage](https://gocover.io/_badge/$url)](https://gocover.io/$url)"
      echo
      return
      ;;

    ping)
      declare server="${1%%/*}"
      ssh "git@$server"
      ;;

    # Uses the mapfile array loading trick to grab all the repos that
    # match the passed arguments. The only different between this and
    # match is that match just returns the match. This prompts for the
    # matching directory to change into if more than one, otherwise it
    # changes into it and echoes the new full path.

    *)
      mapfile -t  matches < <(repo match "$subcmd") # not really a subcmd
      if [[ ${#matches[@]} == 0 ]]; then
        telln 'No repos found.'
        return
      fi
      if [[ ${#matches[@]} == 1 ]]; then
        echo "$REPOS/${matches[0]}"
        cd "$REPOS/${matches[0]}"
        return
      fi
      select one in "${matches[@]}";do
        echo "$REPOS/$one"
        cd "$REPOS/$one"
        break
      done
      ;;

  esac
} && export -f repo && complete -W "list paths discover in mkmanifest
gobadges inpath match create clone delete forcedelete listremote
listremoteother fork private public show ping" repo

# TODO make aware of github as well so can be used for both

save () { 
    local y;
    local repo;
    local user=$(git config user.name);
    [[ -z "$user" ]] && echo "Git doesn't look configured yet." && return 1;
    git rev-parse > /dev/null 2>&1;
    if [[ ! $? = "0" ]]; then
        read -p "Not a git repo. Create? " y;
        if [[ $y =~ ^[yY] ]]; then
            touch README.md;
            read -p "GitLab path: " repo;
            git init;
            git remote add origin "git@gitlab.com:$repo.git";
            git add -A .;
            git commit -a -m initial;
            git push -u origin master;
        fi;
        return 0;
    fi;
    if [[ -z "$(git status -s)" && $(git rev-list --count origin/master..master) = 0 ]]; then
        echo Already at the latest.;
        return 0;
    fi;
    local comment=wip;
    [ ! -z "$*" ] && comment="$*";
    git pull;
    git add -A .;
    git commit -a -m "$comment";
    git push
}

#gh () {
#  declare auth="Authorization: token $(token gh)"
#  declare user=$(basepart $(dirpart $PWD))
#  declare repo=$(basepart $PWD)
#  [[ -n "$2" ]] && repo="$2"
#  [[ -n "$3" ]] && user="$3"
#  case "$1" in
#    create)
#      curl -X POST -H "$auth" -d '{"name":"'"$repo"'","private":true}' "https://api.github.com/user/repos"
#      gh init
#      ;;
#    show)
#      curl -X GET -H "$auth" "https://api.github.com/repos/$user/$repo"
#      ;;
#    clone)
#      mkdir -p ~/repos/$user
#      git clone git@github.com:$user/$repo ~/repos/$user/$repo
#      cd ~/repos/$user/$repo
#      ;;
#    fork)
#      curl -X POST -H "$auth" -d '' "https://api.github.com/repos/$user/$repo/forks" 
#      ;;
#    private)
#      curl -X PATCH -H "$auth" -d '{"private":true}' "https://api.github.com/repos/$user/$repo"
#      ;;
#    public)
#      curl -X PATCH -H "$auth" -d '{"private":false}' "https://api.github.com/repos/$user/$repo"
#      ;;
#    ping)
#      ssh git@github.com
#      ;;
#    init)
#      [[ -d .git ]] && warnln 'Already has a `.git`.' && return
#      touch README.md
#      git init
#      git add README.md
#      git commit -m init
#      git remote add origin "git@github.com:$user/$repo"
#      git push -u origin master
#      ;;
#    delete)
#      danger 'Do you really want to delete `'"$user/$repo"'`?' || return
#      curl -X DELETE -H "$auth" "https://api.github.com/repos/$user/$repo"
#      rm -rf "$HOME/repos/$repo"
#      rm -rf "$HOME/go/src/github.com/$user/$repo"
#      ;;
#    gobadges)
#      echo "![WIP](https://img.shields.io/badge/status-wip-red)"
#      echo "[![GoDoc](https://godoc.org/github.com/$user/$repo?status.svg)](https://godoc.org/github.com/$user/$repo)"
#      echo "[![Go Report Card](https://goreportcard.com/badge/github.com/$user/$repo)](https://goreportcard.com/report/github.com/$user/$repo)"
#      echo "[![Coverage](https://gocover.io/_badge/github.com/$user/$repo)](https://gocover.io/github.com/$user/$repo)"
#      echo
#      ;;
#    *)
#      cd ~/repos/github.com/$(git config user.name)
#      ;;
#  esac
#} && export -f gh && complete -W "create show clone fork init delete private public gobadges ping" gh
#

# Passes the arguments on to curl calling the GitLab GraphQL API. Use to
# construct specific service calls.
    #-d '{"query": "'$q'"}' \

curlgl () {
  declare q=$(argsorin $*)
  echo "$q"
  return
  curl -X POST \
    -H "Authorization: Bearer $(token gitlab.com)" \
    -H 'Content-Type: application/json' \
    -d "{\"query\": \"$q\"}" \
    'https://gitlab.com/api/graphql'
  return $?
} && export -f curlgl

lab () {
  case "$1" in
    private)
      echo would change to private;
    ;;
  *)
    echo unimplemented;
    ;;
  esac
} && export -f lab

