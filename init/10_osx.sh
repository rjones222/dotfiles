# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# fix xcrun
# https://gist.github.com/thelibrarian/5520597
if [! -f /usr/bin/xcrun-orig]; then
  e_header "Fixing xcrun"
  sudo mv /usr/bin/xcrun /usr/bin/xcrun-orig
  sudo echo '#!/bin/bash' >> /usr/bin/xcrun
  sudo echo 'exec "$@"' >> /usr/bin/xcrun
  [! -f /Developer/usr/bin/xcrun] && ln -s /usr/bin/xcrun /Developer/usr/bin/
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew doctor
  brew update
  brew tap phinze/homebrew-cask

  # Install Homebrew recipes.
  recipes=(
    ack
    bash-completion
    brew-cask
    # cowsay
    ctags
    git
    git-extras
    # graphviz
    grc
    highlight
    htop-osx
    man2html
    hub
    id3tool
    imagemagick
    lesspipe nmap
    macvim
    mysql
    nodejs
    qcachegrind
    reattach-to-user-namespace
    ruby
    selenium-server-standalone
    sl
    ssh-copy-id
    the_silver_searcher
    tmux
    tree
    wget
  )

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  # Install brew casks
  casks=(
    cyberduck
    dropbox
    google-chrome
    google-drive
    google-music-manager
    iterm2
    sequel-pro
    virtualbox
  )

  list="$(to_install "${casks[*]}" "$(brew cask list)")"
  if [[ "$list" ]]; then
     e_header "Installing Homebrew casks: $list"
     brew cask install $list
  fi

  # This is where brew stores its binary symlinks
  local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

  # install ctags patched
  cd /usr/local/Library/Formula
  curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
  brew install ctags --HEAD
  cd -

  # htop
  if [[ "$(type -P $binroot/htop)" && "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$binroot/htop"
    sudo chmod u+s "$binroot/htop"
  fi
fi
