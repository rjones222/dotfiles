# dotfiles

My Vim, Git, and other dotfiles. This is now customized from [spf13](https://github.com/spf13/spf13-vim).

# Directions

1. Install spf13 with his installation script: ```curl http://j.mp/spf13-vim3 -L -o - | sh```
2. Clone this repo with submodles into your home directory: ```cd ~ && git clone git@github.com:mikedfunk/dotfiles.git .dotfiles --recursive```
3. Run install script: ```cd ~/.dotfiles && sudo chmod +x install.sh && ./install.sh```
4. Install and Uninstall default bundles: ```vim +BundleInstall! +BundleClean! +qall```

# All in one line

    curl http://j.mp/spf13-vim3 -L -o - | sh && cd ~ && git clone git@github.com:mikedfunk/dotfiles.git .dotfiles --recursive && cd ~/.dotfiles && sudo chmod +x install.sh && ./install.sh && vim +BundleInstall! +BundleClean! +qall
