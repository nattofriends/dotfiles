configure_less () {
    local cachedir=$HOME/.cache/.bashrc.d
    mkdir -p $cachedir

    if [[ "$RC_CACHING" = 1 ]] && [[ -f ${cachedir}/less ]]; then
        source ${cachedir}/less
        return
    fi

    # https://stackoverflow.com/a/42056714/
    # https://unix.stackexchange.com/questions/184597/
    local less="-XRF --mouse"

    local version=$(less --version | head -n 1 | grep -o "\d.*\d")
    # feature added in less 574
    if $(compare_version 574 $version); then
        less="${less} --incsearch"
    fi
    export LESS=$less

    if [[ "$RC_CACHING" = 1 ]]; then
        echo "export LESS='${less}'" > ${cachedir}/less
    fi
}

configure_less
unset configure_less
