autoload -Uz compinit
compinit

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="refined" #"frontcube"

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
plugins=(git golang)
# source $ZSH/oh-my-zsh.sh

# zsh-autosuggestions plugin
# source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

##########################################################
# User configuration
##########################################################

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='hx'

function c { # VSCode
  local args=''
  if [ $# -eq 0 ]; then
    args='.'
  else
    args="$@"
  fi
  code ${args}
}

function em { # Emacs GUI
  # Checks if there's a frame open
  emacsclient -n -e "(if (> (length (frame-list)) 1) ‘t)" 2> /dev/null | grep t &> /dev/null
  if [ "$?" -eq "1" ]; then
    emacsclient -a 'nvim' -nqc "$@" #&> /dev/null
  else
    emacs --daemon
    emacsclient -nq "$@" &> /dev/null
  fi
}

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

# Aliases

alias l='ls -lha'
alias ll='ls -lh'
alias ls='eza --icons --group-directories-first --color=always --git "$@"' # --git
alias ltree='ls --all --tree -L 3 --ignore-glob ".git/" "$@"'

alias g="git"
alias {n,nodejs}="node"
alias v="nvim"
alias gi="gitui --watcher"
alias d="docker"
alias dc="docker compose"
alias k="kubectl"
alias h="helm"
alias tf="terraform"
alias t="task"
alias m="make"
alias ca="cargo"
alias sz="source ~/.zshrc" # sz = source zshrc
alias mz="hx ~/.zshrc"     # mz = modify zshrc

alias gor="go run"
alias got="go test"
alias gob="go build"
alias gov="go vet"
alias goh="go help"
alias gof="go fmt"
alias gol="go list"

hs () {
  history | rg "$@" | bat
}

hh () {
  "$@" --help | less
}

# explorer function
function e {
  if [ -d "/mnt/c" ]; then
    if [ $# -eq 0 ]; then
      explorer.exe `wslpath -w "${PWD}/${dir}"`;
    fi
    for dir in "$@"; do
      explorer.exe `wslpath -w "${PWD}/${dir}"`;
    done
  fi
}

# cd into any repo that is tracked with ghq
function zr {
  local dir
  dir=$(ghq list --full-path | awk '!seen[$0]++' | fzf) && cd "$dir"
}

# cd into any worktree of a bare git repo
function zw {
    local bare_repo_path
    local worktree_dir
    local relative_path

    # Find the bare repository path
    bare_repo_path=$(git worktree list --porcelain | grep '^worktree ' | head -1 | cut -d ' ' -f2)

    # Parse worktree paths, excluding the bare repo, trim the bare repo path, and use fzf to select
    relative_path=$(git worktree list --porcelain | grep '^worktree ' | cut -d ' ' -f2 | grep -v "^$bare_repo_path$" | awk -v base="$bare_repo_path" '{gsub(base, ""); print}' | fzf --height 40% --layout=reverse)

    # Check if a worktree was selected
    if [[ -n $relative_path ]]; then
        worktree_dir="${bare_repo_path}${relative_path}"
        cd "$worktree_dir" || return
    else
        echo "No worktree selected."
    fi
}

# fetch all update from all repos
# that are tracked by ghq
function up {
  init=$(pwd)

  for repo in $(ghq list --full-path | awk '!seen[$0]++'); do
    cd ${repo}
    remote=$(git config --get remote.origin.url)

    # Skip if repo has no remote
    if [[ -n ${remote} ]]; then
      echo -e "\033[0;32mFetching ${repo}\033[0m"
      git fa
    else
      echo -e "\033[0;33mSkipping ${repo}\033[0m"
    fi
  done

  cd ${init}
}

[ -s "$(command -v zoxide)" ]   && eval "$(zoxide init zsh)"
[ -s "$(command -v gh)" ]       && eval "$(gh completion --shell zsh)"
[ -s "$(command -v helm)" ]     && eval "$(helm completion zsh)"
[ -s "$(command -v kubectl)" ]  && eval "$(kubectl completion zsh)"
[ -s "$(command -v cast)" ]     && eval "$(cast completions zsh)"

if [[ $TERM == xterm* && -z $ZELLIJ_SESSION_NAME ]]; then
  zellij -s main || zellij attach main
fi

# ------------------------------------------------------------------------------
