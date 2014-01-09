# ---------------------------------
# custom ps1

# git ps1 prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# git line for ps1
# @link http://stackoverflow.com/questions/4485059/git-bash-is-extremely-slow-in-windows-7-x64
fast_git_ps1 () {
    printf -- "$(tput setab 4)$(tput setaf 7)$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ \1 /')"
}

_my_ps1 () {
    # check non-zero exit status
    local EXIT="$?"

    # start with white fg
    PS1="\["
    PS1+="$(tput setaf 7)"

    # set some background color vars
    local RED="\[$(tput setab 1)\]"
    local GREEN="\[$(tput setab 2)\]"
    local GRAY="\[$(tput setab 6)\]"

    # gray path, git in blue if there is a git repo
    PS1+="$GRAY \w \[$(fast_git_ps1)\]"

    # red if non-zero exit status, otherwise green
    if [ $EXIT != 0 ]; then
        PS1+="$RED"
    else
        PS1+="$GREEN"
    fi

    # ssh text
    if [ -n "$SSH_CLIENT" ]; then PS1+=" ssh"
    fi

    # reset
    PS1+=" \$ \[$(tput sgr0)\] "
    PS1+="\]"
}
export PROMPT_COMMAND="_my_ps1"

# end ps1
# ---------------------------------
