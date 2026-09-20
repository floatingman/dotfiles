# update-all — refresh the tools I keep current on every machine, in one shot.
#
#   omp               omp update         (self-update)
#   pi + extensions   pi update --all    (pi + all installed extensions; bare
#                                        `pi update` is self-only, which is
#                                        why it used to take two runs)
#   herdr             herdr update
#   dotfiles          chezmoi update     (git pull + apply, runs sync scripts)
#
# Tools missing on this machine are skipped with a note. Later steps still run
# when an earlier one fails; exits non-zero if anything failed.
#
# Usage: update-all [--dry-run]
update-all() {
    emulate -L zsh

    local dry=0
    case ${1:-} in
        ('') ;;
        (-n|--dry-run) dry=1 ;;
        (*) print -u2 'usage: update-all [--dry-run]'; return 2 ;;
    esac

    # 'label:command' — label may contain spaces, command is zsh-parsed below.
    local -a specs=(
        'omp:omp update'
        'pi + extensions:pi update --all'
        'herdr:herdr update'
        'chezmoi dotfiles:chezmoi update'
    )

    local -a failed skipped
    local spec label cmd rc t0
    local -a args

    for spec in "${specs[@]}"; do
        label=${spec%%:*}
        cmd=${spec#*:}
        args=(${(z)cmd})

        if (( ! $+commands[${args[1]}] )); then
            skipped+=(${args[1]})
            print -P "%F{yellow}==> skipping ${label//\%/%%} (${args[1]} not installed)%f"
            continue
        fi

        print -P "%F{cyan}==> %f${label//\%/%%}: ${cmd//\%/%%}"
        if (( dry )); then
            continue
        fi

        t0=$SECONDS
        "${args[@]}"
        rc=$?
        if (( rc )); then
            failed+=("${label} (exit ${rc})")
            print -P "%F{red}==> ${label//\%/%%} failed (exit ${rc}), continuing%f"
        else
            print -P "%F{green}==> ${label//\%/%%} done in $(( SECONDS - t0 ))s%f"
        fi
    done

    (( $#skipped )) && print -P "%F{yellow}==> skipped (not installed): ${skipped[*]}%f"
    if (( $#failed )); then
        print -P '%F{red}==> update-all finished with failures:%f'
        printf '  - %s\n' "${failed[@]}"
        return 1
    fi
    (( dry )) || print -P '%F{green}==> update-all finished cleanly%f'
    return 0
}
