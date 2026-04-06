autoload -Uz zrecompile

source_file () {
    local file=$1

    if [[ -e "$file" ]]; then
        source $file
        zcompare $file &!
        rc_debug "Sourcing $file"
    else
        rc_debug "File $file does not exist, skipping"
    fi
}

source_dir () {
    local dir=$1
    [[ -d "$dir" ]] || return

    if [[ "$RC_CACHING" = 1 ]]; then
        local cachedir=~/.cache/.bashrc.d
        local cachefile=$cachedir/digest_${dir:t}.zsh

        if [[ -s "$cachefile.zwc" && ! "$dir" -nt "$cachefile.zwc" ]]; then
            rc_debug "using digest for $dir"
            source "$cachefile"
            return
        fi
    fi

    local files=($dir/*.(zsh|sh)(N))
    [[ ${#files} -eq 0 ]] && return

    local f
    for f in $files; do
        rc_debug "Sourcing $f"
        source $f
    done

    if [[ "$RC_CACHING" = 1 ]]; then
        {
            [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
            for f in $files; do
                zcompare $f
            done
            cat "${files[@]}" > "$cachefile"
            zcompare $cachefile
        } &!
    fi
}

# Function to determine the need of a zcompile. If the .zwc file
# does not exist, or the base file is newer, we need to compile.
# These jobs are asynchronous, and will not impact the interactive shell
zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
        if zcompile -U "${1}.tmp.zwc" "${1}"; then
            mv -f "${1}.tmp.zwc" "${1}.zwc"
        fi
    fi
}

# vim: ft=sh
