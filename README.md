# dotfiles

My Vim, Git, and other dotfiles. This is now customized from [spf13](https://github.com/spf13/spf13-vim).

# Directions

1. Install spf13 with his installation script
1. Clone this repo into your home directory
1. Init submodules: ```git submodule update --init```
2. Create symlinks:
    2. ```ln -s vimrc.local ~/.vimrc.local```
    2. ```ln -s vimrc.bundles.local ~/.vimrc.bundles.local```
    3. ```ln -s gitconfig ~/.gitconfig```
    4. ```ln -s profile ~/.profile```
    5. ```ln -s tmux.conf ~/.tmux.conf```
    6. ```ln -s gitignore ~/.gitignore```
    7. ```ln -s UltiSnips ~/.vim```
3. Uninstall default bundles: ```vim +BundleClean! +qall```
3. Install vundle bundles: ```vim +BundleInstall +qall```
