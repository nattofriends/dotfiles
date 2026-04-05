# See also .bashrc.d/94-completion-git.sh

if command -v git >/dev/null; then
    # Should do this in a better way
    if [[ ! -e generated/_git ]]; then
        if [[ -e /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh ]]; then
            ln -sf /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh generated/_git
        else
            curl -L -o generated/_git -s --compressed https://raw.githubusercontent.com/felipec/git-completion/refs/heads/master/src/_git
        fi
    fi
fi
