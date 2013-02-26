# Unified .bashrc for natto
# Domains special cases: warosu.org, ocf.berkeley.edu, (EE)CS.Berkeley.EDU

case $OSTYPE in
solaris2.10)  DOMAINNAME=domainname ;;
linux-gnu)  DOMAINNAME=dnsdomainname ;;
esac

DOMAIN=$($DOMAINNAME)

####################
# Sourcing
####################

case $DOMAIN in
ocf.berkeley.edu)
    if [ -r /opt/ocf/share/environment/.bashrc ]; then
      source /opt/ocf/share/environment/.bashrc
    fi
    ;;
CS.Berkeley.EDU | EECS.Berkeley.EDU)
    [[ -z ${MASTER} ]] && export MASTER=${LOGNAME%-*}
    [[ -z ${MASTERDIR} ]] && export MASTERDIR=$(eval echo ~${MASTER})
    ;;
esac

##################
# Aliases
##################

LS='ls -lhALHF --color=auto --group-directories-first'
case $OSTYPE in
solaris2.10)  alias ls='g$LS' ;;
linux-gnu)  alias ls='$LS' ;;
esac

alias clears="clear; echo -ne '\e[3J'"
alias iotop='iotop -oPd 0.5'
alias ltmux="(cd $HOME; if tmux has 2> /dev/null; then tmux -u attach; else tmux -u new; fi)"
alias naon=nano
alias nnao=nano

if [ "ocf.berkeley.edu" == $DOMAIN ]; then
    alias plogout="pkill -u $(whoami)"
    alias server-status='ssh death wget -qO - http://localhost/server-status?auto'
    alias apt-dater="ssh -t lightning sudo /opt/puppet/scripts/apt-dater.sh"
    alias print-stats="ssh -t printhost print/stats.py"
    alias kinit-forever="kinit -l52w"
fi

if [ -d "/.git" ]; then # This machine is git controlled
    alias update-git="ssh-agent sh -c 'cd /; ssh-add ~/.ssh/id_rsa_gitcontrol; git pull'"
fi

##################
# Exports
##################

export PATH=$HOME/local/bin:$PATH
export EDITOR=nano

# Don't export xterm if we already exported screen (probably remote ssh)
[ "$TERM" != "screen-256color" ] && export TERM='xterm-256color'
# Only export screen if we're in tmux.
[ -n "$TMUX" ] && export TERM=screen-256color
# Then fix if we're on Solaris.
[ "solaris2.10" == "$OSTYPE" ] && export TERM=xterm

case $DOMAIN in
warosu.org)
    alias update-upgrade='aptitude update; aptitude upgrade -DWVZ'
    [ "melon" == $(hostname) ] && export PHABRICATOR_ENV='custom/local'
    ;;
esac

# So much overhead! It hurts!
function parse_git_branch {
  [[ -e `which git` ]] && git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

# Begone, colors!
PS1='[\D{%m/%d %R:%S}] \u $(tput bold)\w $(parse_git_branch)$ $(tput sgr0)'

# tmux start tests -- only for supernova.ocf.berkeley.edu and tomato.warosu.org
if [ -z "$TMUX" ]; then
    case $DOMAIN in
    ocf.berkeley.edu)  [ "supernova" == $(hostname) ] && ltmux ;;
    warosu.org)  [ "tomato" == $(hostname) ] && ltmux ;;
    esac
fi


