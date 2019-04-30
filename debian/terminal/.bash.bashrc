# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls -a $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# fancy colored prompt (WIP)
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_GRAY='\e[1;30m'
export COLOR_NC='\e[0m'
export COLOR_TEAL='\e[36m'

path () {

    if [ $(pwd) == "/" ]; then
        :
    elif [ $(pwd) == ${HOME} ]; then
        :
    elif [[ $(pwd) == ${HOME}/* ]]; then
        HOMELEN=${#HOME}
        HOMECPY="`dirname $(pwd)`"
        MIDDLE=${HOMECPY:HOMELEN}
        if [[ -z $MIDDLE ]]; then
          MIDDLE="/"
        else
          MIDDLE="${MIDDLE}/"
        fi
        echo "~$MIDDLE"
    elif [ $(dirname $(pwd)) == "/" ]; then
        echo -n "/"
    else
        VAR=`dirname $(pwd) && echo "/"`
        echo -n "${VAR//[[:space:]]/}"
    fi
}

PS1="\[${COLOR_GRAY}\][\t] \[${COLOR_LIGHT_PURPLE}\]\u\[${COLOR_GRAY}\]@\[${COLOR_LIGHT_GREEN}\]\h: \[${COLOR_GRAY}\]\$(path)\[${COLOR_TEAL}\]\W \[${COLOR_GRAY}\]\$\[${COLOR_NC}\] "

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi
