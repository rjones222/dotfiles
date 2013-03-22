# dotfiles

My Vim, Git, and other dotfiles. This is now customized from [spf13](https://github.com/spf13/spf13-vim)

# Directions

1. Install spf13 with his installation script
1. clone this repo into your home directory
2. create symlinks:
    2. ```ln -s vimrc.local ~/.vimrc.local```
    2. ```ln -s vimrc.bundles.local ~/.vimrc.bundles.local```
    3. ```ln -s gitconfig ~/.gitconfig```
    4. ```ln -s profile ~/.profile```
    5. ```ln -s tmux.conf ~/.tmux.conf```
    6. ```ln -s gitignore ~/.gitignore```
3. uninstall default bundles: ```vim +BundleClean! +qall```
3. install vundle bundles: ```vim +BundleInstall +qall```
