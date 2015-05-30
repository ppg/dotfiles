alias ..="cd .."

# Node.js aliases
alias mocha="./node_modules/mocha/bin/mocha --reporter mocha-better-spec-reporter"
alias grunt=./node_modules/grunt-cli/bin/grunt

# GREP aliases
alias grep="grep --color=auto"
alias grip="grep -i --color=auto"
if type rgrep >/dev/null 2>&1; then
  alias rgrep="rgrep -n --color=auto"
  alias rgrip="rgrep -ni --color=auto"
else
  alias rgrep="grep -nr --color=auto"
  alias rgrip="grep -nir --color=auto"
fi
