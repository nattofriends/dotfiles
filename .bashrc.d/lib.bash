source_file () {
    local file=$1

    if [[ -e "$file" ]]; then
        source $file
        rc_debug "Sourcing $file"
    else
        rc_debug "File $file does not exist, skipping"
    fi
}

source_dir () {
    local dir=$1

    if [[ -d "$dir" ]]; then
        local files=$(echo "${dir}/*.@(sh|bash)")
        for i in $files; do
            if [ -r $i ]; then
                rc_debug "Sourcing $i"
                . $i
            fi
          done
        unset i
    else
        rc_debug "Directory $dir does not exist, not sourcing"
    fi
}

# vim: ft=sh
