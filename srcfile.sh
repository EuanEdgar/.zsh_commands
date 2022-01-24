COMMANDS_PATH="$HOME/.zsh_commands"

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

function get_status {
  if [ $TERM_PROGRAM = iTerm.app ]; then
    git_root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ $? != 0 ]; then
      if [[ "${PWD##$HOME}" != "${PWD}" ]]; then
        s="~${PWD#"$HOME"}"
      else
        s=$PWD
      fi
    else
      s="$(basename $git_root_dir)${PWD#"$git_root_dir"}"
    fi

    set_status $s 'prompt'
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

PROMPT='%{$(update_colour)%}%{$(get_status)%}%m$(git_super_status_wrapper)%# '

if [ -s /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#cd commands
alias htdocs="cd ~/../../Applications/MAMP/htdocs"

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
    be rake routes | grep $search
  else
    be rake routes
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
alias hosts="atom /etc/hosts"
alias refresh_dns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

#Fuck
unalias fuck 2>/dev/null # Prevent parse error when reloading file
eval $(thefuck --alias)
alias fuck="fuck -r"

alias reload="source ~/.zshrc"

#Tools
alias devserve="$COMMANDS_PATH/apps/php_serve.sh"

alias rb="ruby $COMMANDS_PATH/apps/rb.rb"
alias escape_spaces="rb -l \"gsub(' ', '\ ')\""

alias swap="$COMMANDS_PATH/apps/swap.sh"

alias prettyping="$COMMANDS_PATH/apps/prettyping --nolegend"

alias cat="bat"

alias backup="$COMMANDS_PATH/apps/backup.sh"

if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
  # alias colour="$COMMANDS_PATH/apps/colour.sh"
  source "$COMMANDS_PATH/apps/colour2.sh"
  source "$COMMANDS_PATH/apps/folder_colour.sh"
  source "$COMMANDS_PATH/apps/cd.sh"
  source "$COMMANDS_PATH/apps/preexec.sh"

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

  set_folder_colour
fi

# NVM
nvmAvilable=$(which nvm && echo 0)
if [[ !nvmAvilable = 0 ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
unset nvmAvilable

#AUTROLOAD!
autoload -Uz compinit && compinit

get_status
