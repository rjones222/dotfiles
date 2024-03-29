#!/usr/bin/env bash
echo "Installing Mike Funk's dotfiles"

# create this if it doesn't exist - we'll need it later.
if [[ ! -d "/usr/local/bin" ]]; then
    echo "creating /usr/local/bin (requires sudo)"
    sudo mkdir -p /usr/local/bin
fi

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
    echo "ERROR: XCode or the Command Line Tools for XCode must be installed first."
    exit 1
fi

# If Git is not installed, install it (Ubuntu only, since Git comes standard
# with recent XCode or CLT)
if [[ ! "$(type -P git)" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
    echo "Installing Git"
    sudo apt-get -qq install git-core
fi

# If Git isn't installed by now, something exploded. We gots to quit!
if [[ ! "$(type -P git)" ]]; then
    echo "ERROR: Git should be installed. It isn't. Aborting."
    exit 1
fi

# Download or update.
if [[ ! -d ~/.dotfiles ]]; then

    # ~/.dotfiles doesn't exist? Clone it!
    echo "Cloning dotfiles to ~/.dotfiles"
    cd
    git clone --recursive https://github.com/mikedfunk/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
else

    # Make sure we have the latest files.
    echo "Updating dotfiles"
    cd ~/.dotfiles
    git pull
    git submodule update --init --recursive --quiet
fi

# source installer support files
for f in ~/.dotfiles/install/support/*; do
    # only source files
    if [[ -f $f ]]; then
        source $f
    fi
done

# now source install scripts. These should run in alphanumeric order.
for f in ~/.dotfiles/install/*; do
    # only source files
    if [[ -f $f ]]; then
        source $f
    fi
done

log_info "Installation complete!"
