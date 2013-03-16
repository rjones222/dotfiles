dotfiles
========

my vim, git, and other dotfiles
after cloning, do this:

1. init submodules: ```git submodule update --init```
2. create symlinks:
 1. ```ln -s .vim ~/.vim```
 2. ```ln -s .vimrc ~/.vimrc```
 3. ```ln -s .gitconfig ~/.gitconfig```
 4. ```ln -s .profile ~/.profile```
 
 3. install vundle bundles: ```vim +BundleInstall +qall```
