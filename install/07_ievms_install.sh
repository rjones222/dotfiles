#!/usr/bin/env bash

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
# install ievms for testing. requires virtualbox.
# @link https://github.com/xdissent/ievms
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

# uncomment this to install ievms for IE 9, 10, and 11
# if [[ ! "$(type -P virtualbox)" ]]; then
    # log_error "cannot install ievms - virtualbox not installed!"
# else
    # log_info "Beginning ievms install script"
    # curl -s https://raw.githubusercontent.com/xdissent/ievms/master/ievms.sh | env IEVMS_VERSIONS="9 10 11" bash
# fi
# log_info "End ievms install script"
