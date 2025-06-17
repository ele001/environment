### HyperSwitch
[Disable "HyperSwitch expired!" window](https://gist.github.com/xqin/20a51ea523a738acfe6773616a26b2c9?permalink_comment_id=5521427)

```bash
cd /Applications/HyperSwitch.app/Contents/MacOS/

cp HyperSwitch HyperSwitch.original

cp HyperSwitch.original HyperSwitch.unsigned

codesign --remove-signature HyperSwitch.unsigned

printf "03B202: 8D\n01146C4: 0C" | xxd -r - HyperSwitch.unsigned

mv HyperSwitch.unsigned HyperSwitch


rm HyperSwitch.original # remove HyperSwitch.original, if you want
```

### zsh
``` bash
# ~/.zshrc: executed by Zsh for interactive shells.

# Only run if interactive
[[ $- != *i* ]] && return

# History settings
HISTCONTROL=ignoreboth     # Zsh doesn't support this directly; use setopt equivalents
setopt hist_ignore_dups     # Don't record duplicates
setopt hist_ignore_space    # Ignore lines starting with space
setopt append_history       # Append to history file, don't overwrite
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history

# Automatically update LINES and COLUMNS
autoload -Uz add-zsh-hook
function update_term_size() {
  (( LINES = $(tput lines) ))
  (( COLUMNS = $(tput cols) ))
}
add-zsh-hook precmd update_term_size

# globstar (recursive globbing like **)
setopt glob_dots       # Also include dotfiles
# Recursive globstar is supported natively: **/*.ext works by default

# Lesspipe support
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Set chroot name in prompt
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot=$(< /etc/debian_chroot)
fi

# Color prompt
autoload -U colors && colors
if [[ "$TERM" == xterm-color || "$TERM" == *-256color ]]; then
  color_prompt=yes
fi

if [[ "$color_prompt" == yes ]]; then
  PROMPT='${debian_chroot:+($debian_chroot)}%F{green}%n@%m%f:%F{blue}%~%f$ '
else
  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~$ '
fi
PROMPT='%F{green}%n@%m %~ %% %f'
unset color_prompt

# Set terminal title
case "$TERM" in
xterm*|rxvt*)
  precmd() { print -Pn "\e]0;%n@%m: %~\a" }
  ;;
esac

# Enable color support for ls and grep
if [[ -x /usr/bin/dircolors ]]; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  # alias dir='dir --color=auto'
  # alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings (uncomment if needed)
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# alert alias
alias alert='notify-send --urgency=low -i "$([[ $? = 0 ]] && echo terminal || echo error)" "$(fc -ln -1 | sed -e '\''s/^[ \t]*[0-9]\+[ \t]*//;s/[;&|]\s*alert$//'\'' )"'

# Load .zsh_aliases if present
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Enable completion
autoload -Uz compinit
compinit


defaults write com.apple.screencapture disable-shadow -bool TRUE

export HTTP_PROXY=http://127.0.0.1:7897
export HTTPS_PROXY=http://127.0.0.1:7897

export PATH="$HOME/Library/Python/3.9/bin:$PATH"



# Added by Windsurf
export PATH="/Users/admin/.codeium/windsurf/bin:$PATH"

alias python=python3
```
