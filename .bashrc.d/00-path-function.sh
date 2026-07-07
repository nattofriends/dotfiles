function pathcheck {
    [[ -d "$1" && ":$PATH:" != *":$1:"* ]]
}

function pathprepend {
    pathcheck "$1" && PATH="$1:${PATH}"
}

function pathappend {
    pathcheck "$1" && PATH="${PATH}:$1"
}
