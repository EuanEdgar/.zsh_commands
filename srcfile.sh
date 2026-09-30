COMMANDS_PATH="$HOME/.zsh_commands"
HAS_TOUCHBAR=''

export PATH="$COMMANDS_PATH/zsh-git-prompt/src/.bin:$PATH"

if [ -e /usr/local/opt/zsh-git-prompt/zshrc.sh ]; then
  source /usr/local/opt/zsh-git-prompt/zshrc.sh
else
  # Fall back to cloned repo
  source $COMMANDS_PATH/zsh-git-prompt/zshrc.sh
fi

ZSH_THEME_GIT_PROMPT_PREFIX=" %1d/("
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{~%G%}"
setopt PROMPT_SUBST

copy_function() {
  test -n "$(declare -f "$1")" || return
  eval "${_/$1/$2}"
}

rename_function() {
  copy_function "$@" || return
  unset -f "$1"
}

check_git() {
  git rev-parse --quiet 2>/dev/null
}

function get_status {
  if [ -z $TAB_NAME ]; then
    set_folder_tab_name
  fi
  if [ ! -z $TAB_NAME ]; then
    if [ $TERM_PROGRAM = iTerm.app ]; then
      if [[ ! -z $HAS_TOUCHBAR ]]; then
        set_status $TAB_NAME 'prompt'
      else
        set_title $TAB_NAME 'prompt'
      fi
    fi
  fi
}

update_colour() {
  if [ ! -z $RESET_COLOUR ]; then
    colour prev
    export RESET_COLOUR=''
  fi
}

function git_super_status_wrapper {
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    git_super_status
  fi
}

# python is not installed by default anymore
alias python=python3
alias pip=pip3

random () {
  local rr
  rr=$(( 1 + $RANDOM % $# ))
  echo $@[${rr}]
}

precmd() {
  update_colour
  get_status
}
pretty_pwd() {
  p=$(pwd)
  if [[ $p == $HOME* ]]; then
    echo "${p/${HOME}/~}"
  else
    echo $p
  fi
}
PROMPT="$(random 🦀 🐙 🦎 🦑 🦋 🐝 🦕 🦆)\$(check_git || echo \" \$(pretty_pwd)\")\$(git_super_status_wrapper)
> "

if [ -s /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#Rails commands
alias be="bundle exec"
alias rcon="colour orange; bundle exec rails c; colour prev"
alias rsp="be rspec --format doc"
alias rgrep="ps aux | grep rspec"
routes() {
  search=$1
  if [[ -n "$search" ]]; then
    be rails routes | grep $search
  else
    be rails routes
  fi
}

# shasum
alias sha1sum="shasum"
alias sha256sum="shasum --algorithm 256"

#Shut down
alias die="sudo shutdown -h now"

#Gulp
alias gulpit="gulp && gulp watch"

#Ruby stuff
alias _irb="command irb"
alias irb="pry"

#DNS
alias hosts="cod /etc/hosts"
alias refresh_dns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

#Fuck
unalias fuck 2>/dev/null # Prevent parse error when reloading file
eval $(thefuck --alias)
alias fuck="fuck -r"

alias reload="source ~/.zshrc"

#Tools
source "$COMMANDS_PATH/apps/reverse_find_file.sh"

alias devserve="$COMMANDS_PATH/apps/php_serve.sh"

alias rb="ruby $COMMANDS_PATH/apps/rb.rb"
alias escape_spaces="rb -l \"gsub(' ', '\ ')\""

alias swap="$COMMANDS_PATH/apps/swap.sh"

alias prettyping="$COMMANDS_PATH/apps/prettyping --nolegend"

alias wait_for_docker="$COMMANDS_PATH/apps/wait_for_docker.sh"
source "$COMMANDS_PATH/apps/docker.sh"

source "$COMMANDS_PATH/apps/date.sh"

alias copy_pnpm_audit_status="$COMMANDS_PATH/apps/pnpm_audit_status.sh"

alias cat=bat

alias backup="$COMMANDS_PATH/apps/backup.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
  # alias colour="$COMMANDS_PATH/apps/colour.sh"
  source "$COMMANDS_PATH/apps/colour2.sh"
  source "$COMMANDS_PATH/apps/folder_colour.sh"
  source "$COMMANDS_PATH/apps/set_folder_tab_name.sh"

  function set_status {
    if [[ ! -z  "$2" ]] && [ $2 = 'prompt' ]; then
      if [ -z $CUSTOM_STATUS ]; then
        ~/.iterm2/it2setkeylabel set status $1
      fi
    else
      export CUSTOM_STATUS='true'
      ~/.iterm2/it2setkeylabel set status $1
    fi
  }

  function clear_status {
    export CUSTOM_STATUS=''
  }

  function title {
    echo -ne "\033]0;"$*"\007"
  }

  function set_title {
    if [[ ! -z "$2" ]] && [ $2 = 'prompt' ]; then
      if [ -z $CUSTOM_TITLE ]; then
        title $1
      fi
    else
      export CUSTOM_TITLE='true'
      title $1
    fi
  }

  function clear_title {
    export CUSTOM_TITLE=''
  }

  set_folder_colour
fi

source "$COMMANDS_PATH/apps/set_node_version.sh"
source "$COMMANDS_PATH/apps/cd.sh"
source "$COMMANDS_PATH/apps/preexec.sh"

function ngrok-host {
  colour '#1f1e37'
  ngrok http --domain spydr.ngrok.io $@
  colour prev
}

function disable_thread_safety {
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
  export DISABLE_SPRING=true
}

source "$COMMANDS_PATH/apps/wrappers/cod.sh"
source "$COMMANDS_PATH/apps/wrappers/curse.sh"

#AUTROLOAD!
autoload -Uz compinit && compinit

source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

get_status

set_node_version
folder_commands

ssh-add -l > /dev/null 2>&1 || ssh-add

alias nproc="sysctl -n hw.physicalcpu"
alias ssl_health_check="$COMMANDS_PATH/apps/ssl_health_check"

