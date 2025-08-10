# DEBUG 
# because sourcing is super slow
# At the very top
# START_TIME=$(/bin/date +%s)
# echo "Starting zshrc load"

# =============================================
# SYSTEM
# =============================================

# DEBUG 
# echo "Loading powerlevel10k..."
# P10K_START=$(/bin/date +%s)

export ZSH="/Users/me/.oh-my-zsh"

# remove duplicate entries from path/PATH
# see https://zsh.sourceforge.io/Guide/zshguide02.html#l24
typeset -U path

# Powerlevel10k. Should stay close to the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# DEBUG 
# P10K_END=$(/bin/date +%s)
# echo "Powerlevel10k loaded in $(($P10K_END - $P10K_START)) seconds"

# =============================================
# BEHAVIORS
# =============================================

# DEBUG 
# echo "Loading BEHAVIORS..."
# OMZ_START=$(/bin/date +%s)

# Case-sensitive completion.
CASE_SENSITIVE="false"

# Hyphen-insensitive completion.
# Case-sensitive completion must be off.
# _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# OMZ auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Display dir contents when current working dir changes.
chpwd() {
  eza_col_icons
}

# View man docs in Neovim.
export MANPAGER='nvim +Man!'
# Why is the suggested approach so different?
# export MANPATH="/usr/local/man:$MANPATH"
export MANWIDTH=999

# DEBUG 
# OMZ_END=$(/bin/date +%s)
# echo "BEHAVIORS loaded in $(($OMZ_END - $OMZ_START)) seconds"


# =============================================
# LOOKS
# =============================================

# DEBUG 
# echo "Loading LOOKS..."
# P10K_START=$(/bin/date +%s)

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# More colors
# Not a 100% sure what this does exactly.
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# DEBUG 
# P10K_END=$(/bin/date +%s)
# echo "LOOKS loaded in $(($P10K_END - $P10K_START)) seconds"

# =============================================
# PLUGINS
# =============================================

# DEBUG 
# echo "Loading PLUGINS..."
# P10K_START=$(/bin/date +%s)

# Standard plugins: ZSH/plugins/
# Custom plugins: $ZSH_CUSTOM/plugins/
plugins=(git dirhistory zoxide zsh-syntax-highlighting zsh-autosuggestions)

if [[ -r  $ZSH/oh-my-zsh.sh ]] then
  source $ZSH/oh-my-zsh.sh
fi

# DEBUG 
# P10K_END=$(/bin/date +%s)
# echo "PLUGINS loaded in $(($P10K_END - $P10K_START)) seconds"

# =============================================
# ALIASES
# =============================================
# Can make modules: see $ZSH_CUSTOM folder.

alias mkdir="mkdir -pv"
alias conf="nvim ~/dotfiles"
alias zshconf="nvim ~/.zshrc"
alias zconf="nvim ~/.zshrc"
alias vconf="nvim ~/dotfiles/nvim"
alias vimconf="nvim ~/dotfiles/nvim"
alias tmuxconf="nvim ~/dotfiles/tmux/.tmux.conf"
alias wezconf="nvim ~/dotfiles/wezterm/wezterm.lua"

dutop() {
  du -sh "${1:-.}"/* 2>/dev/null | sort -hr | head -10
}

# Specific software
open_with_chrome() {
  if [[ -z "$1" ]]; then
    echo "Usage: chrome <filename>"
    exit 1
  fi

  open -a "/Applications/Google Chrome.app/" "$1"
}
eza_col_icons() {
  command eza -1F --color=always --icons=always --sort=name --group-directories-first "$@"
}

alias chrome="open_with_chrome"
alias eza="eza_col_icons"
alias l="eza_col_icons"

## Vim
VIM_CONFIG_PATH=/Users/me/.config/nvim

alias v="nvim"
# Simply type 'v' to open CWD
alias v="quickvim"
alias vimconf="nvim $VIM_CONFIG_PATH"

function quickvim() {
  if [ -n "$1" ]
  then
    nvim "$@"
  else
    nvim "."
  fi
}

# =============================================
# SETUP FOR SPECIFIC SOFTWARE
# =============================================

# Set prompt for p10k theme
# (automatically added by p10k setup wizard)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

eval "$(zoxide init zsh)"

# nvm -- Node version manager
export NVM_DIR="$HOME/.nvm"
[ -r "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -r "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Prioritize MacPorts Python over system one.
export PATH="/opt/local/bin:$PATH"

# Add home-baked scripts.
export PATH="$HOME/dev/bash/scripts:$PATH"
# Add Cheatsheets.
export PATH="$PATH:$HOME/dev/bash/cheatsheets"
# Add FASM
export PATH="$PATH:$HOME/dev/asm/fasm/source/macos/x64"

# =============================================
# VIM MODE
# =============================================

# For some reason this has to be close to the end
# Or at least it does not work when under BEHAVIORS

# DEBUG 
# echo "Loading VIM mode..."
# OMZ_START=$(/bin/date +%s)

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q' # Steady block cursor for normal mode
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q' # Steady beam cursor for insert mode
  fi
}

# Initialize cursor as beam shape when zsh starts
function zle-line-init {
  echo -ne '\e[6 q' # Start with beam cursor
}

# Make sure cursor is beam shape when zsh finishes
function zle-line-finish {
  echo -ne '\e[6 q'
}

# Sync with clipboard. Thanks, Claude.
function vi_yank_pbcopy {
  # Added this test to try to speed up sourcing zhrc
  if [[ "$WIDGET" == "vi_yank_pbcopy" ]]; then
    zle vi-yank
    echo "$BUFFER" | pbcopy
  fi
    # DEBUG
    # LOGFILE="/tmp/zsh-debug.log"
    # {
    #   echo -n ""
    #   echo "BUFFER: $BUFFER"
    #   echo "CUTBUFFER: $CUTBUFFER"
    #   echo "LBUFFER: $LBUFFER"
    #   echo "RBUFFER: $RBUFFER"
    # } > $LOGFILE 
    # echo ""
    #
    # For some reason, this only prints first two lines.
    # Maybe a limitation of the zle widget environment.
    # cat "$LOGFILE"
    #
    # Create a macOS notification (this runs asynchronously)
    # (osascript -e 'display notification "Text copied to clipboard" with title "ZSH Yank"' &)
}

function enable_vim() {
  bindkey -v
  zle -N zle-keymap-select
  zle -N zle-line-init
  zle -N zle-line-finish
  # Ensure correct cursor when starting zsh/new prompt
  echo -ne '\e[6 q' # Beam cursor on startup

  zle -N vi_yank_pbcopy
  bindkey -M vicmd 'y' vi_yank_pbcopy

  # bindkey -M vicmd 'k' vi-history-search-backward
  # bindkey -M vicmd 'j' vi-history-search-forward
}

# DO IT
enable_vim

# DEBUG 
# OMZ_END=$(/bin/date +%s)
# echo "VIM loaded in $(($OMZ_END - $OMZ_START)) seconds"

# =============================================
# UNUSED BUT INTERESTING
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
