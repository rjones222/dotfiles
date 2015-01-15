#!/usr/env/bin bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
#
#  ___  ____ _         ______           _
#  |  \/  (_) |        |  ___|         | |
#  | .  . |_| | _____  | |_ _   _ _ __ | | __
#  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
#  | |  | | |   <  __/ | | | |_| | | | |   <
#  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
#
# bash aliases
# more info at http://mikefunk.com
# }}}

[ -f ~/.bash_env ] && source ~/.bash_env
[ -f ~/.bash_paths ] && source ~/.bash_paths
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.bash_completions ] && source ~/.bash_completions
[ -f ~/.promptline.theme.bash ] && source ~/.promptline.theme.bash
[ -f ~/.private_vars.sh ] && source ~/.private_vars.sh

# source bash completions
[ -d ~/.dotfiles/to_link/bash_completion.d ] && for f in ~/.dotfiles/to_link/bash_completion.d/*; do source $f; done
