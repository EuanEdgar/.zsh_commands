if [ -z $COMMANDS_PATH ]; then
  echo 'Set COMMANDS_PATH to the path to .zsh_commands.'
  exit 1
fi

check_if_installed(){
  which $1
  installed=$?
}

check_if_installed brew
if [[ $installed = 0 ]]; then
  os="mac"
else
  check_if_installed apt
  if [[ $installed = 0 ]]; then
    os="ubuntu"
  fi
fi


if [[ $os = "ubuntu" ]]; then
  sudo apt update
fi

check_if_installed npm
if [[ $installed = 1 ]]; then
  echo "install npm to continue"
  unset installed
  exit 1
fi
unset installed

# nvm is a function, check if dir exists instead
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

if [[ $os = "mac" ]]; then
  if [ ! brew list rbenv ]; then
    brew install rbenv
  fi
else
  echo "Follow instructions to install rbenv here: https://github.com/rbenv/rbenv"
fi

#Git diff-so-fancy
check_if_installed diff-so-fancy
# If not installed
if [[ $installed = 1 ]]; then
  sudo npm install -g diff-so-fancy
fi
# If already installed or successfuly installed
check_if_installed diff-so-fancy
if [[ $installed = 0 ]]; then
  sudo git config --global core.pager "diff-so-fancy | less --tabs=2 -RFX"
else
  echo "diff-so-fancy install failed."
  echo "continuing..."
fi
unset installed

# git git
git config --global alias.git '!exec git'

git config --global alias.delete-merged "!git branch --merged >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches; rm /tmp/merged-branches"

git config --global core.excludesfile "${COMMANDS_PATH}/.gitignore_global"

# TLDR
check_if_installed tldr
# If not installed
if [[ $installed = 1 ]]; then
  sudo npm install -g tldr
fi

check_if_installed tldr
if [[ $installed = 1 ]]; then
  echo "tldr install failed"
  echo "continuing..."
fi
unset installed


check_if_installed thefuck
if [[ $installed = 1 ]]; then
  if [[ $os = "mac" ]]; then
    brew install thefuck
  elif [[ $os = "ubuntu" ]]; then
    sudo apt install python3-dev python3-pip
    sudo pip3 install thefuck
  fi
fi

check_if_installed thefuck
if [[ $installed = 1 ]]; then
  echo "thefuck install failed"
  echo "continuing..."
fi
unset installed

check_if_installed brew
if [[ $installed = 0 ]]; then
  if [ ! -e /usr/local/opt/zsh-git-prompt/zshrc.sh ]; then
    brew install zsh-git-prompt
  fi
fi
unset installed

check_if_installed brew
if [[ $installed = 0 ]]; then
  if [ ! -e /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    brew install zsh-syntax-highlighting
  fi
fi
unset installed

check_if_installed bat
if [[ $installed = 1 ]]; then
  if [[ $os = "mac" ]]; then
    brew install bat

    check_if_installed bat
    if [[ $installed ]]; then
      echo "bat install failed\
      continuing..."
    fi
  elif [[ $ox = "ubuntu" ]]; then
    echo "To install bat (cat replacement), follow instructions here:\
    https://github.com/sharkdp/bat#installation"
  fi
fi

unset installed

chmod +x "$COMMANDS_PATH/apps/swap.sh"
chmod +x "$COMMANDS_PATH/apps/php_serve.sh"

if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
  chmod +x "$COMMANDS_PATH/apps/colour.sh"
fi

echo "To load iterm2 profiles, open preferences -> profiles -> other actions -> import JSON profiles and load ${COMMANDS_PATH}/.iterm2_profiles.json"
