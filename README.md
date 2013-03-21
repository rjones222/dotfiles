# dotfiles

My Vim, Git, and other dotfiles.
after cloning, do this:

1. init submodules: ```git submodule update --init```
2. create symlinks:
    1. ```ln -s vim ~/.vim```
    2. ```ln -s vimrc ~/.vimrc```
    3. ```ln -s gitconfig ~/.gitconfig```
    4. ```ln -s profile ~/.profile```
    5. ```ln -s tmux.conf ~/.tmux.conf```
	6. ```ln -s gitignore ~/.gitignore``` 
3. install vundle bundles: ```vim +BundleInstall +qall```
