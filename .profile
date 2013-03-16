alias wr='cd ~/Sites'
alias selenium='java -jar /usr/local/bin/selenium-server.jar'
alias gitk='gitk 2>/dev/null'
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
PATH=$PATH:/Applications/VirtualBox.app/Contents/MacOS
PATH=$PATH:~/.bin
export PATH
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
