# include brew on our path
if [[ $(uname -s) == "Darwin" ]]; then
	export PATH=$PATH:/usr/local/bin:/usr/local/sbin
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
