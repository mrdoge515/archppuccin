###############
### History ###
###############

HISTSIZE=5000
HISTFILE=~/.local/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


################
### Keybinds ###
################

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


###############
### Aliases ###
###############

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ssh='kitten ssh'


#############
### zinit ###
#############

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit, if it's not installed
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

autoload -U compinit && compinit


#################
### Utilities ###
#################

# Automatically start ssh agent and add keys to github
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [ ! -f "$SSH_AUTH_SOCK" ]; then
	source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

if [ -n "$SSH_AUTH_SOCK" ]; then
	if ! ssh-add -l | grep -q 'AuthKey'; then
		ssh-add "$HOME"/.ssh/AuthKey 2>/dev/null
	fi
fi


##################
### oh-my-posh ###
##################

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
