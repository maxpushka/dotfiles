# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="" #"agnoster"
fpath+=$ZSH/themes/typewritten
autoload -U promptinit; promptinit
prompt typewritten
export TYPEWRITTEN_PROMPT_LAYOUT="pure"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git golang zsh-autosuggestions gh)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias v="nvim"
alias {p,python}="python3"
alias {n,nodejs}="node"
alias d="docker"
alias dc="docker-compose"
alias gi="gitui"
alias k="kubectl"

alias semacs="/usr/bin/emacs --daemon &"
alias emacs='emacsclient --create-frame --alternate-editor="" &'

# explorer function
e () {
  if [ -d "/mnt/c" ]; then
    if [ $# -eq 0 ]; then
      explorer.exe `wslpath -w "${PWD}/${dir}"`;
    fi
    for dir in "$@"; do
      explorer.exe `wslpath -w "${PWD}/${dir}"`;
    done
  fi
}

function isWindows {
  [[ $PWD == *"/mnt/"* ]]
}

# choose right git exectutable for WSL
function git {
  if isWindows; then
    echo "[using Git for Windows]"
    git.exe "$@"
  else
    /usr/bin/git "$@"
  fi
}

alias ls=choose_ls
function choose_ls {
  if isWindows; then
    powershell.exe dir
  else
    exa --icons --sort=type --git --color=always "$@"
  fi
}

function ltree {
  if isWindows; then
    tree "$@"
  else
    ls --all --tree -L 2 "$@"
  fi
}

alias ns="notify-send $(tmux display-message -p '#S:#P')"
if [ -z "$TMUX" ] && [ ${UID} != 0 ]; then
  tmux new-session -A -s main;
fi

[ -s "$(command -v zoxide)" ]  && eval "$(zoxide init zsh)"
[ -s "$(command -v gh)" ]      && eval "$(gh completion --shell zsh)"
[ -s "$(command -v helm)" ]    && eval "$(helm completion zsh)"
[ -s "$(command -v kubectl)" ] && eval "$(kubectl completion zsh)"
