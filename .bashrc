# Nikita Kouevda
# 2013/12/04

# Return if not an interactive shell
[[ "$-" != *i* ]] && return

# Review commands with history expansion before executing; retype if failed
shopt -s histverify histreedit

# Append to the history file instead of overwriting it
shopt -s histappend

# Ignore commands that start with whitespace; ignore and erase duplicates
export HISTCONTROL="ignoreboth:erasedups"

# Use Vim as the default editor
export EDITOR="vim"

# Color grep matches by default
export GREP_OPTIONS="--color=auto"

# System-dependent aliases
if [[ "$(uname -s)" == "Linux" ]]; then
    alias la="ls -Abhlp --color=auto"
    alias reverse="tac"
else
    alias la="ls -Abhlp -G"
    alias reverse="tail -r"
fi

# Temporary file for deduplicating the history file
tmp_histfile="/tmp/.bash_history.$$"

# Synchronize the current history list with the history file
function sync_history() {
    # Append the history list to the history file
    history -a

    # Remove duplicates from the history file, keeping the most recent copies
    if [[ -r "$HISTFILE" ]]; then
        reverse "$HISTFILE" | awk '!uniq[$0]++' | reverse > "$tmp_histfile"
        mv "$tmp_histfile" "$HISTFILE"
    fi

    # Clear the history list and read the history file
    history -c
    history -r
}

# Synchronize history before every prompt
export PROMPT_COMMAND="sync_history;$PROMPT_COMMAND"

# Color escape sequences
reset="$(tput sgr0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"

# Red user if root, green otherwise
[[ $UID -eq 0 ]] && user="\[$red\]" || user="\[$green\]"

# Red @ if display unavailable, green otherwise
[[ -z "${DISPLAY+set}" ]] && at="\[$red\]" || at="\[$green\]"

# Red host if connected via ssh, green otherwise
[[ -n "${SSH_CONNECTION+set}" ]] && host="\[$red\]" || host="\[$green\]"

# Yellow working directory
dir="\[$yellow\]"

# Red $ or # if non-zero exit status, normal otherwise
symbol='$([[ $? -ne 0 ]] && printf "%b" "$red" || printf "%b" "$reset")'

# user@host pwd $
export PS1="\[$reset\]$user\u$at@$host\h $dir\W \[$symbol\]\\$ \[$reset\]"

# If it exists and is readable, source ~/.bash_local
[[ -r ~/.bash_local ]] && . ~/.bash_local

# Guarantee exit status 0
:
