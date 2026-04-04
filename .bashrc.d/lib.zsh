source_file () {
    local file=$1

    if [[ -e "$file" ]]; then
        source $file
        ( zcompare $file ) &!
        rc_debug "Sourcing $file"
    else
        rc_debug "File $file does not exist, skipping"
    fi
}

source_dir () {
    local dir=$1

    if [[ -d "$dir" ]]; then
        for i in $dir/*.(zsh|sh); do
            if [ -r $i ]; then
                rc_debug "Sourcing $i"
                . $i
                ( zcompare $i ) &!
            fi
          done
        unset i
    fi
}

# Function to determine the need of a zcompile. If the .zwc file
# does not exist, or the base file is newer, we need to compile.
# These jobs are asynchronous, and will not impact the interactive shell
zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
        zcompile ${1}
    fi
}

# vim: ft=sh
