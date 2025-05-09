# To enable, export ENABLE_SOCKMINDER=1 in .bashrc_prelocal.

# 1. Before every command, link .ssh/sock to the most recently active client.
function relink_sock {
    if [[ "$RELINK_DONE" == "1" ]]; then
        return
    fi

    if [[ "$_TMUX_SUPPORTS_CLIENT_PID" == "0" ]]; then
        sock=$(grep $(tmux list-clients -F "#{client_activity} #{client_tty}" | sort -r | head -n 1 | cut -d ' ' -f 2) < $TMPDIR/.sockminder.$USER | cut -d ' ' -f 2)
    else
        sock=$(grep -aPo '(?<=SSH_AUTH_SOCK=)[^\0]+' /proc/$(tmux list-clients -F "#{client_activity} #{client_pid}" | sort -r | head -n 1 | cut -d ' ' -f 2)/environ)
    fi

    # Link the sock to the most recent client
    # If the client didn't have a SSH_AUTH_SOCK, this will be just empty.
    if [[ "$sock" == *agent.* ]]; then
        ln -sf $sock ~/.ssh/sock
    fi

    RELINK_DONE=1
}

# 2. Clear the early return out once all prompt commands (which constitute the bulk of
# extra DEBUG traps are done)
function reset_relink_done {
    RELINK_DONE=0
}

# Cleanup function when using the file method
function clean_sockminder {
    # Remove disconnected clients from the sockminder
    SOCKMINDER=$TMPDIR/.sockminder.$USER
    (grep -P $(who | sed -r "/^$USER/! d; s/.*(pts\/[[:digit:]]+).*/\1/" | paste -sd '|') $SOCKMINDER > $SOCKMINDER.tmp && mv $SOCKMINDER.tmp $SOCKMINDER) & disown
}

function write_sockminder {
    SOCKMINDER=$TMPDIR/.sockminder.$USER
    sort -u <(grep -v $(tty) $SOCKMINDER) <(echo $(tty) $SSH_AUTH_SOCK) > $SOCKMINDER.tmp && mv $SOCKMINDER.tmp $SOCKMINDER
    clean_sockminder
}

[[ -n $(command -v tmux) && $(tmux -V | tr -dc '0-9') -le 20 ]]
_TMUX_SUPPORTS_CLIENT_PID=$?

[ -e "/proc" ]
_SYSTEM_SUPPORTS_PROCFS=$?

if [[ "$ENABLE_SOCKMINDER" == "1" ]]; then
    rc_log "Enabling sockminder"
    if [[ -n "$TMUX" ]]; then
        trap relink_sock DEBUG
        PROMPT_COMMAND="$PROMPT_COMMAND; reset_relink_done"
    else
        if [[ "$_TMUX_SUPPORTS_CLIENT_PID" == "0" ]]; then
            echo "Warning: tmux too old to support sock relinking using client_pid method, using file method"
            write_sockminder
        elif [[ "$_SYSTEM_SUPPORTS_PROCFS" == "1" ]]; then
            echo "Warning: system does not support procfs (/proc), using file method"
            write_sockminder
        fi
    fi
else
    # Fallback to last-login-wins
    rc_log "Not enabling sockminder (ENABLE_SOCKMINDER=${ENABLE_SOCKMINDER})"
    if [[ -z "$TMUX" && -n "$SSH_AUTH_SOCK" ]]; then
        ln -sf $SSH_AUTH_SOCK ~/.ssh/sock
    fi
fi
