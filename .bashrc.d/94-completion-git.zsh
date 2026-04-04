if command -v git >/dev/null; then
    if [[ -e /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]]; then
        zstyle ':completion:*:*:git:*' script /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
    else
        curl -o ~/.cache/bashrc.d/git-completion.bash --compressed https://raw.githubusercontent.com/felipec/git-completion/refs/heads/master/src/git_completion.bash
    fi
fi
