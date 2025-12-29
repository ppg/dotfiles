alias ..="cd .."

# Node.js aliases
#alias mocha="./node_modules/mocha/bin/mocha --reporter mocha-better-spec-reporter"
alias mocha="npx mocha"
alias grunt="npx grunt"

# GREP aliases
if command -v ggrep >/dev/null 2>&1; then
  alias grep="ggrep --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
  alias grip="ggrep -i --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
else
  alias grep="grep --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
  alias grip="grep -i --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
fi
if command -v rgrep >/dev/null 2>&1; then
  alias rgrep="rgrep -n --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
  alias rgrip="rgrep -ni --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
else
  alias rgrep="ggrep -nr --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
  alias rgrip="ggrep -nir --color=auto --exclude-dir=.cache --exclude-dir=.devspace --exclude-dir=.git --exclude-dir=node_modules --extended-regexp"
fi

# sudo apt-get install python-pygments python3-pygments
alias catc='pygmentize -g'

alias dps='docker ps --format "table {{.Names}}\t{{.Status}}"'
alias dc='docker compose'
alias dcps='docker compose ps --format "table {{.Names}}\t{{.Status}}"'
alias dcl='docker-compose'
alias dcci='docker compose --file docker-compose.ci.yml'
alias dccips='docker compose ps --format "table {{.Names}}\t{{.Status}}"'
alias dccil='docker-compose --file docker-compose.ci.yml'

alias k='kubectl'

# get dns on ubuntu
alias dnsinfo='nmcli device show wlp4s0 | grep IP4.DNS'

# clean text from color codes and ^M
alias cleantxt=$'sed \'s/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&\'"\'"\'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]|
//g\''

# Prints the CAs from a crt fileregistered on a system
#   print_cert_subjects < /etc/ssl/certs/ca-certificates.crt
alias print_cert_subjects="awk -v cmd='openssl x509 -noout -subject' ' /BEGIN/{close(cmd)};{print | cmd}'"
alias print_cert_issuers="awk -v cmd='openssl x509 -noout -issuer' ' /BEGIN/{close(cmd)};{print | cmd}'"
alias printcas="print_cert_subjects < /etc/ssl/certs/ca-certificates.crt"

gh_pr_approve() {
  url="$1"
  body="$2"
  gh pr review "$url" --approve --body "$body" || echo "$url"
}

# Go through per-job aliases
conf_dir=~/.bash_aliases.d
if [[ -d "${conf_dir}" ]]; then
  for file in "${conf_dir}"/*; do
    if [[ -f "${file}" ]]; then
      # shellcheck disable=SC1090
      source "${file}"
    fi
  done
fi
