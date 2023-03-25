alias ..="cd .."

# Node.js aliases
#alias mocha="./node_modules/mocha/bin/mocha --reporter mocha-better-spec-reporter"
alias mocha="npx mocha"
alias grunt="npx grunt"

# GREP aliases
if command -v ggrep >/dev/null 2>&1; then
  alias grep="ggrep --color=auto --exclude-dir=node_modules --perl-regexp"
  alias grip="ggrep -i --color=auto --exclude-dir=node_modules --perl-regexp"
else
  alias grep="grep --color=auto --exclude-dir=node_modules --perl-regexp"
  alias grip="grep -i --color=auto --exclude-dir=node_modules --perl-regexp"
fi
if command -v rgrep >/dev/null 2>&1; then
  alias rgrep="rgrep -n --color=auto --exclude-dir=node_modules --perl-regexp"
  alias rgrip="rgrep -ni --color=auto --exclude-dir=node_modules --perl-regexp"
else
  alias rgrep="ggrep -nr --color=auto --exclude-dir=node_modules --perl-regexp"
  alias rgrip="ggrep -nir --color=auto --exclude-dir=node_modules --perl-regexp"
fi

# sudo apt-get install python-pygments python3-pygments
alias catc='pygmentize -g'

alias dc='docker compose'
alias dcl='docker-compose'
alias dcci='docker compose --file docker-compose.ci.yml'
alias dccil='docker-compose --file docker-compose.ci.yml'

# get dns on ubuntu
alias dnsinfo='nmcli device show wlp4s0 | grep IP4.DNS'

# clean text from color codes and ^M
alias cleantxt=$'sed \'s/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&\'"\'"\'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]|
//g\''

# Prints the CAs registered on a system
alias printcas="awk -v cmd='openssl x509 -noout -subject' ' /BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt"

export HOME=/home/ppgengler
export LDAP_USERNAME=ppgengler

# Go through per-job aliases
readonly conf_dir=~/.bash_aliases.d
for file in "${conf_dir}"/*; do
  # shellcheck disable=SC1090
  source "${file}"
done
