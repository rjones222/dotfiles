# dotfiles

My Bash, Vim, Git, and other dotfiles. Recently re-done to remove bash-it, bash-installer-framework, spf13-vim. Much faster now! I've commented all config files and install scripts indicating *why* I'm doing what I'm doing. Check the install directory to see what each install task does.

![Screenshot](https://raw.githubusercontent.com/mikedfunk/dotfiles/support/screenshot.png)

# Directions

1. If on mac, install [XCode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) and ensure you run it at least once. You need the full XCode, not just the command line tools for [MacVim](https://github.com/b4winckler/macvim) and [Terminal Notifier](https://github.com/alloy/terminal-notifier).
2. Ensure git is installed with `which git`. On Mac just do `git status` somewhere and it will offer to install the XCode Command Line Tools.
3. Install dotfiles: `git clone https://github.com/mikedfunk/dotfiles.git ~/.dotfiles --recursive && ~/.dotfiles/install.sh -r`

Or pick an install script in the `install` directory and run them one at a time.

# Other stuff to install:

* [XCode Command Line Tools](https://developer.apple.com/downloads/index.action) for Mac
* [iTerm 2](https://iterm2.com/downloads.html)
* [Google Chrome](https://www.google.com/intl/en/chrome/browser/#brand=CHMB&utm_campaign=en&utm_source=en-ha-na-us-sk&utm_medium=ha)
* [Google Drive](https://tools.google.com/dlpage/drive)
* [Spectacle](http://spectacleapp.com/)
* [VirtualBox](http://virtualbox.org)
* [Vagrant](http://www.vagrantup.com/downloads)
* [Vagrant vbguest plugin](https://github.com/dotless-de/vagrant-vbguest)
* [IE VMs](https://github.com/xdissent/ievms)
* [Sequel Pro](http://www.sequelpro.com/) for Mac or [MySQL Workbench](http://dev.mysql.com/downloads/tools/workbench/) for Windows/Linux
* NetExtender or [SonicWall Mobile Connect](https://itunes.apple.com/us/app/sonicwall-mobile-connect/id466931806/?mt=8) for vpn access
