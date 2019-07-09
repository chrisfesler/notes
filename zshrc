# windows-terminal wants to start in a weird place
cd ~/ 

source_if_exists() {
	if [[ -f $1 ]]; then
		source $1;
	fi
}

export HISTFILE=~/.zsh_history
# TODO why both of these?
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt hist_reduce_blanks
setopt share_history # between shells
setopt HIST_IGNORE_SPACE # don't record if starts with a space

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# initialilze zplug
export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "djui/alias-tips", from:github
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "lib/completion", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
#zplug "zsh-users/zsh-syntax-highlighting", defer:2
# must load after zsh-syntax-highlighting, per https://github.com/zsh-users/zsh-history-substring-search
zplug "zsh-users/zsh-history-substring-search", from:github, defer:3
# uncomment to play with buffalo
#zplug "1995parham/buffalo.zsh", from:github

if ! zplug check --verbose; then
	printf "Install zplug plugins? [y/N]"
	if read -q; then
		echo; zplug install
	fi
fi

zplug load

# history-substring-search bound to arrow keys -- none of these work!
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '\E[A' history-substring-search-up
bindkey '\E[B' history-substring-search-down
bindkey '\EOA' history-substring-search-up
bindkey '\EOB' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# but these do
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# vi edit mode on the command line
set -o vi

source_if_exists ~/.zsh_aliases

