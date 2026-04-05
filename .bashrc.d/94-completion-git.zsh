configure_completion_git () {
    # See also .metaconf/zsh-completions/50-git.sh

    if (( $+commands[git] )); then
        if [[ -e /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]]; then
            zstyle ':completion:*:*:git:*' script /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
        else
            local cachedir=~/.cache/.bashrc.d
            local cachefile=$cachedir/git-completion.bash
            zstyle ':completion:*:*:git:*' script $cachefile
            (
                if [[ ! -e $cachefile ]]; then
                    {
                        [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
                        curl -L -o $cachefile -s --compressed \
                            https://raw.githubusercontent.com/felipec/git-completion/refs/heads/master/src/git-completion.bash
                    } &!
                fi
            ) &!
        fi
    fi
}

configure_completion_git
unset configure_completion_git
