if command -v git >/dev/null; then
    if [[ -e /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]]; then
        zstyle ':completion:*:*:git:*' script /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
    else
        (
            if [[ ! -e ~/.cache/.bashrc.d/git-completion.bash ]]; then
                mkdir -p ~/.cache/.bashrc.d
                curl -o ~/.cache/.bashrc.d/git-completion.bash --silent --compressed \
                    https://raw.githubusercontent.com/felipec/git-completion/refs/heads/master/src/git_completion.bash
            fi
        ) &!
    fi
fi
