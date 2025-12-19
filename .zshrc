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
bindkey '^H' backward-kill-word


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

export NEWT_COLORS="root=#1e1e2e,#cdd6f4 border=#313244,#7f849c window=#1e1e2e,#1e1e2e shadow=#11111b,#11111b title=#f2cdcd,#1e1e2e button=#313244,#cba6f7 button_active=#313244,#f9e2af actbutton=#f9e2af,#1e1e2e compactbutton=#f9e2af,#1e1e2e checkbox=#f38ba8,#1e1e2e entry=#94e2d5,#1e1e2e disentry=#585b70,#585b70 textbox=#94e2d5,#1e1e2e acttextbox=#f5c2e7,#1e1e2e label=#89dceb,#1e1e2e listbox=#94e2d5,#1e1e2e actlistbox=#f5c2e7,#1e1e2e sellistbox=#f38ba8,#1e1e2e actsellistbox=#1e1e2e,#f9e2af"


##################
### oh-my-posh ###
##################

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
