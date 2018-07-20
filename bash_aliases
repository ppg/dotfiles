alias ..="cd .."

# Node.js aliases
#alias mocha="./node_modules/mocha/bin/mocha --reporter mocha-better-spec-reporter"
alias mocha="./node_modules/mocha/bin/mocha"
alias grunt=./node_modules/grunt-cli/bin/grunt

# GREP aliases
alias grep="grep --color=auto --exclude-dir=node_modules"
alias grip="grep -i --color=auto --exclude-dir=node_modules"
if type rgrep >/dev/null 2>&1; then
  alias rgrep="rgrep -n --color=auto --exclude-dir=node_modules"
  alias rgrip="rgrep -ni --color=auto --exclude-dir=node_modules"
else
  alias rgrep="grep -nr --color=auto --exclude-dir=node_modules"
  alias rgrip="grep -nir --color=auto --exclude-dir=node_modules"
fi

# sudo apt-get install python-pygments python3-pygments
alias catc='pygmentize -g'

alias dc='docker-compose'
alias dcci='docker-compose --file docker-compose.ci.yml'

# get dns on ubuntu
alias dnsinfo='nmcli device show wlp4s0 | grep IP4.DNS'
