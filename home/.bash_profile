# If not running interactively, run like a coward
[[ -z "$PS1" ]] && return;

# include brew on our path
if [[ $(uname -s) == "Darwin" ]]; then
	export PATH=/usr/local/bin:/usr/local/sbin:$PATH
	export HOMEBREW_DEVELOPER=1
fi

# things that I like
alias ll='ls -la'

# setup $PS1
function updatePS1()
{
    hostcolor="\[\e[0;36m\]"
    pathcolor="\[\e[0;33m\]"

    if [[ "$USER" == "root" ]]; then
        usercolor="\[\e[0;31m\]"
    else
        usercolor="\[\e[0;36m\]"
    fi

    if [[ "$USER" == "root" ]]; then
        symb="#"
    else
        symb="\$"
    fi
    nocolor="\[\e[0m\]"
    export PS1="$hostcolor\H${nocolor}:$pathcolor\W$nocolor $usercolor\u$nocolor [\t]$symb "
}

# Actually call it
updatePS1

# Setup nice aliases for starting/stopping buildslaves
alias buildslave_start="(cd ~/buildbot && sandbox/bin/buildslave start slave)"
alias buildslave_stop="(cd ~/buildbot && sandbox/bin/buildslave stop slave)"
function buildslave_pause
{
    PAUSE="$1"
    if [[ -z "$PAUSE" ]]; then
        PAUSE=3600
    fi
    buildslave_stop
    echo "Starting buildslave again in $PAUSE seconds"
    (sleep $PAUSE && buildslave_start >/dev/null 2>/dev/null) &
}


# If we're not inside tmux, try to attach:
if [[ -z "$TMUX" ]]; then
    # look for an unattached session. Also filter out sessions with names that start with _
    session=$(tmux list-sessions 2>/dev/null | egrep -v "\(attached\)$" | cut -d: -f1 | egrep -v "^_" | head -1)

    if [[ $? != 0 ]]; then
        # This means that tmux isn't even running
        session=0
        tmux new-session -d -s $session
    elif [[ -z "$session" ]]; then
        # This means that there are no unattached sessions.  Let's come up with a new (unique) session number:
        session=$(tmux list-sessions 2>/dev/null | egrep -v "^_" | awk -F: '{if(max==""){max=$1}; if($1>max) {max=$1}}; END {print max+1;}')
        tmux new-session -d -s $session
    fi

    # Finally, we attach to that session
    tmux attach -t $session
    echo "You have now exited tmux, exit again to disconnect"
fi