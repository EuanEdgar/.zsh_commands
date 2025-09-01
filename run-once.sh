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

check_if_installed yarn
if [[ $installed = 1 ]]; then
  npm i --g yarn
fi
unset installed

# nvm is a function, check if dir exists instead
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

if [[ $os = "mac" ]]; then
  brew install rbenv
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

check_if_installed git-filter-repo
if [[ $installed = 1 ]]; then
  if [[ $os = "mac" ]]; then
    brew install git-filter-repo
  elif [[ $os = "ubuntu" ]]; then
    apt install git-filter-repo
  fi
fi

# git git
git config --global alias.git '!exec git'

git config --global alias.delete-merged "!git branch --merged | grep -v '^\\*' > /tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches; rm /tmp/merged-branches"

git config --global alias.uncommit "reset --soft HEAD^"

git config --global alias.checkout-pr "!f() {\
  if [ -z \"\$1\" ]; then\
    echo 'Usage: git checkout-pr <PR number>';\
    return 1;\
  fi;\
  if git show-ref --verify --quiet refs/heads/pr-\$1; then\
    echo \"Branch pr-\$1 already exists, checking it out\";\
    git checkout pr-\$1;\
    return 0;\
  fi;\
  git fetch origin pull/\$1/head:pr-\$1 && git checkout pr-\$1;\
}; f"

git config --global alias.delete-pr "!f() {\
  if [ -z \"\$1\" ]; then\
    echo 'Usage: git delete-pr <PR number>';\
    return 1;\
  fi;\
  if ! git show-ref --verify --quiet refs/heads/pr-\$1; then\
    echo \"Branch pr-\$1 does not exist\";\
    return 1;\
  fi;\
  git branch -D pr-\$1;\
}; f"

git config --global alias.delete-all-prs "!f() {\
  git branch --format='%(refname:short)' | grep -E '^pr-\d+$' | while read branch; do\
    git branch -D \"\$branch\";\
  done;\
}; f"

git config --global core.excludesfile "${COMMANDS_PATH}/.gitignore_global"

git config --global user.name "EuanEdgar"
git config --global user.email "euan@spicerack.co.uk"

if [ -d ~/.gnupg ]; then
  git config --global commit.gpgsign true
fi

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

check_if_installed ag
if [[ $installed = 1 ]]; then
  brew install the_silver_searcher
fi

check_if_installed ag
if [[ $installed = 1 ]]; then
  echo "silver searcher install failed"
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
  elif [[ $os = "ubuntu" ]]; then
    echo "To install bat (cat replacement), follow instructions here:\
    https://github.com/sharkdp/bat#installation"
  fi
fi

unset installed

check_if_installed aws
if [[ $installed = 1 ]]; then
  if [[ $os = "mac" ]]; then
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg" &&\
      sudo installer -pkg AWSCLIV2.pkg -target / &&\
      rm AWSCLIV2.pkg
  else
    echo "You should install the AWS CLI"
  fi
fi
unset installed


chmod +x "$COMMANDS_PATH/apps/swap.sh"
chmod +x "$COMMANDS_PATH/apps/php_serve.sh"

if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
  chmod +x "$COMMANDS_PATH/apps/colour.sh"
fi

echo "To load iterm2 profiles, open preferences -> profiles -> other actions -> import JSON profiles and load ${COMMANDS_PATH}/.iterm2_profiles.json"
