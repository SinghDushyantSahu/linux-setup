if [ "$EUID" -eq 0 ]; then
    # If Root - Red Theme
    PS1='\[\e[32m\]┌── \[\e[31;1m\]\u\[\e[31m\]@\h \[\e[38;5;46;1m\]\w\n\[\e[32m\]╰─ \[\e[31;1m\]# \[\e[0m\]'
    # Command autocompletion feature using Tab
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
    fi
else
    # If Non-root - Blue Theme
    PS1='\[\e[32m\]┌── \[\e[94;1m\]\u\[\e[94m\]@\h \[\e[38;5;46;1m\]\w\n\[\e[32m\]╰─ \[\e[94;1m\]$ \[\e[0m\]'
fi
