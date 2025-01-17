#!/usr/bin/env zsh

##
# Check if TTY if on OpenBSD
##
if [[ "$(uname)" == "OpenBSD" ]]; then
    if [[ "$(tty)" == "/dev/ttyC"* ]]; then
        export TERM=wsvt25
    fi
fi

##
# ENV VARS
##
export PAGER="less"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="emacsclient -nw -c -a ''"
export VISUAL="emacsclient -c -a ''"

##
# export $PATH
##
export PATH=$PATH:/usr/games:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin

##
# Lazy Loading
##
source ~/.zshrc.d/defer/zsh-defer.plugin.zsh

##
# Autoload zmv
##
zsh-defer autoload -Uz zmv

##
# Setup Completions
##
zsh-defer autoload -U compinit
zsh-defer compinit
zsh-defer autoload -U bashcompinit
zsh-defer bashcompinit

# We don't need to load OpenBSD completions on non-OpenBSD Systems
if [[ "$(uname)" == "OpenBSD" ]]; then
    fpath=($HOME/.zshrc.d/openbsd/completions $HOME/.zshrc.d/completions/src $fpath)
else
    fpath=($HOME/.zshrc.d/completions/src $fpath)
fi
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
zsh-defer eval "$(register-python-argcomplete pipx)"

##
# Java Stuff
##
export PATH=$PATH:/usr/local/jdk-17/bin
export JAVA_HOME=/usr/local/jdk-17/

##
# Elixir/Erlang Stuff
##
export PATH=$PATH:/usr/local/lib/erlang26/bin

##
# Go Stuff
##
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

##
# Autopair
##
zsh-defer source ~/.zshrc.d/autopair/autopair.zsh
zsh-defer autopair-init

##
# Suggestions
##
zsh-defer source ~/.zshrc.d/suggest/zsh-autosuggestions.plugin.zsh

##
# Syntax Highlight
##
zsh-defer source ~/.zshrc.d/fsh/fast-syntax-highlighting.plugin.zsh

##
# History substring search
##
zsh-defer source ~/.zshrc.d/substring/zsh-history-substring-search.plugin.zsh
HISTFILE="$HOME/.zshrc.d/.history"
HISTSIZE=10000000
SAVEHIST=10000000

##
# Vim-mode
##
zsh-defer source ~/.zshrc.d/vim-mode/zsh-vim-mode.plugin.zsh

##
# FZF-Zsh
##
if command -v fzf &> /dev/null; then
    zsh-defer source ~/.zshrc.d/fzf/fzf-tab.plugin.zsh
    zsh-defer source ~/.zshrc.d/fzf-comp/zsh/fzf-zsh-completion.sh
    if [[ "$(uname)" == "OpenBSD" ]]; then
        export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ebdbb2,bg:#282828,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f'
    fi
fi

##
# 256-Color
##
zsh-defer source ~/.zshrc.d/256/zsh-256color.plugin.zsh

##
# Ruby Stuff
##
export GEM_HOME="$HOME/.gems"
export PATH=$PATH:$HOME/.gems/bin

##
# Alias for muscle memory
##
if whence -p doas &> /dev/null; then
    alias sudo="doas"
    alias su="echo 'did you mean to run doas -s? '"
elif whence -p sudo &> /dev/null; then
    alias doas="sudo"
    alias su="echo 'did you mean to run sudo -i? '"
fi

##
# Alias for CD
##
if command -v zoxide &> /dev/null; then
    zsh-defer eval "$(zoxide init --cmd cd zsh)"
fi

##
# Alias for listing files
##
if command -v eza &> /dev/null; then
    alias ls="eza --icons=never -Hh"
    alias la="eza --icons=never -ah"
    alias ll="eza --icons=never -lh"
    alias lh="eza --icons=never -lAh"
    alias tree="eza --icons=never -Th"
elif command -v colorls &> /dev/null; then
    alias ls="colorls -G -Hh"
    alias la="colorls -G -ah"
    alias ll="colorls -G -lh"
    alias lh="colorls -G -lAh"
fi

##
# Alias for parsing
##
if command -v bat &> /dev/null; then
    export BAT_THEME=ansi
    alias cat="bat -pp"
    alias bat="bat -p"
fi
if command -v rg &> /dev/null; then
    alias rgrep="rg"
fi

##
# Alias for editing
##
alias edit=$EDITOR
alias vedit=$VISUAL

##
# Alias for media
##
alias audio-dlp="yt-dlp -x --audio-quality 0 --audio-format vorbis \
	--concurrent-fragments 5"
alias video-dlp="yt-dlp --write-subs --sub-format srt --remux-video mkv \
	--embed-subs --concurrent-fragments 5"
alias tidal-dlp="tidal-dl -o /home/izder456/Music -q Master -r P1080 -l "

##
# Prompt
##
if [[ "$(uname)" == "OpenBSD" ]]; then
    PROMPT="%B%F{yellow}%~%f%b%B % %b"
elif [[ "$(uname)" == "FreeBSD" ]]; then
    PROMPT="%B%F{red}%~%f%b%B % %b"
else
    PROMPT="%B%F{blue}%~%f%b%B % %b"
fi

##
# Bat
##

if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias bathelp='bat --plain --language=help'

    # Manpager with bat
    function man {
        command man "$@" | eval ${MANPAGER}
    }

    # Help Page with bat
    function help {
        "$@" --help 2>&1 | bathelp
    }
fi



##
# Tere config
##
function tere {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

##
# Binds
##

bindkey "5A" previous-history
bindkey "5B" next-history
bindkey "5C" forward-word
bindkey "5D" backward-word

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

##
# Functions For OpenBSD
##

if [[ "$(uname)" == "OpenBSD" ]]; then
    function src {
        local _usage
        _usage="src [file]"
        [ -z $1 ] && echo $_usage
        [ ! -z $1 ] &&
            cd /usr/src/*/$1 || return
    }

    function port {
        local _usage
        _usage="port [port]"	
        [ -z $1 ] && echo $_usage
        [ ! -z $1 ] &&
            cd /usr/ports/*/$1 2>/dev/null ||
                cd /usr/ports/*/*/$1 2>/dev/null ||
                return
    }

    function pclean {
        rm -v **/*.orig **/*(.NL0)
    }

    function revert_diffs {
        zmv -v '**/*.orig' '${f%.orig}'
    }

    function cdw {
        cd $(make show=WRKSRC)
    }

    function maintains {
        local _usage
        _usage="maintains [port]"
        [ -z $1 ] && echo $_usage
        [ ! -z $1 ] &&
            (
                cd /usr/ports/*/$1 >/dev/null 2>&1 &&
                    make show=MAINTAINER ||
                        echo "No port '/usr/ports/*/$1'"
            )
    }
fi

##
# the r/unixporn rite of passage
##
if command -v crfetch &> /dev/null; then
    crfetch
fi

zsh-defer . $HOME/.shellrc.load
