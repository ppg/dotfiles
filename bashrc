#! /bin/bash
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# Changed for rvm
#[ -z "$PS1" ] && return
if [[ -n "$PS1" ]] ; then

  # append to the history file, don't overwrite it
  shopt -s histappend

  # Save multi-line commands as one command
  shopt -s cmdhist

  # Record each line as it gets issued
  PROMPT_COMMAND='history -a'

  # Huge history. Doesn't appear to slow things down, so why not?
  #HISTSIZE=1000
  #HISTFILESIZE=2000
  HISTSIZE=500000
  HISTFILESIZE=100000

  # don't put duplicate lines in the history. See bash(1) for more options
  # ... or force ignoredups and ignorespace
  #HISTCONTROL="ignoredups:ignorespace"
  HISTCONTROL="erasedups:ignoreboth"

  # Don't record some commands
  HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

  # Use standard ISO 8601 timestamp
  # %F equivalent to %Y-%m-%d
  # %T equivalent to %H:%M:%S (24-hours format)
  HISTTIMEFORMAT='%F %T '

  # Enable incremental history search with up/down arrows (also Readline goodness)
  # Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
  bind '"\e[C": forward-char'
  bind '"\e[D": backward-char'


  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize

  # make less more friendly for non-text input files, see lesspipe(1)
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # set variable identifying the chroot you work in (used in the prompt below)
  if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
  fi

  # set a fancy prompt (non-color, unless we know we "want" color)
  case "$TERM" in
      xterm-color) color_prompt=yes;;
  esac

  # uncomment for a colored prompt, if the terminal has the capability; turned
  # off by default to not distract the user: the focus in a terminal window
  # should be on the output of commands, not on the prompt
  #force_color_prompt=yes
  if [ -n "$force_color_prompt" ]; then
      if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
          # We have color support; assume it's compliant with Ecma-48
          # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
          # a case would tend to support setf rather than setaf.)
          color_prompt=yes
      else
          color_prompt=
      fi
  fi

  if [ "$color_prompt" = yes ]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  else
      PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
  unset color_prompt force_color_prompt

  # If this is an xterm set the title to user@host:dir
  case "$TERM" in
  xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
  *)
      ;;
  esac

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      #alias dir='dir --color=auto'
      #alias vdir='vdir --color=auto'

      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi
  # Add color for OSX
  export CLICOLOR=1
  #export LSCOLORS=ExFxCxDxBxegedabagacad
  #export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx


  # some more ls aliases
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'

  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  # Alias definitions.
  # You may want to put all your additions into a separate file like
  # ~/.bash_aliases, instead of adding them here directly.
  # See /usr/share/doc/bash-doc/examples in the bash-doc package.
  if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
  fi

  # Restore default behavior for Gnome >= 3.8
  if [ -f /etc/profile.d/vte.sh ]; then . /etc/profile.d/vte.sh; fi

  # NOTE: bash completion must be before things like the git prompt setup

  # enable bash completion in interactive shells
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi

  # https://docs.brew.sh/Shell-Completion
  if type brew 2&>/dev/null; then
    for COMPLETION in $(brew --prefix)/etc/bash_completion.d/*
    do
      [[ -f $COMPLETION ]] && source "$COMPLETION"
    done
    if [[ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]];
    then
      source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
    fi
    # TODO(ppg); how do do this on OSX in 'normal' way?
    for COMPLETION in ~/.bash_completion.d/*
    do
      [[ -f $COMPLETION ]] && source "$COMPLETION"
    done
    for COMPLETION in ~/.bash_completion.d/darwin/*
    do
      [[ -f $COMPLETION ]] && source "$COMPLETION"
    done
  fi

  # Prepend local/bin for rbenv to override things like git
  # and local/sbin for homebrew
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH

  # Add ~/.local/bin and ~/bin if they exist
  # NOTE: should be done by ubuntu automatically; double check on osx
  [[ -d "${HOME}/.local/bin" ]] && [[ "${PATH}" != *"${HOME}/.local/bin" ]] && PATH="${HOME}/.local/bin:${PATH}"
  [[ -d "${HOME}/bin" ]] && [[ "${PATH}" != *"${HOME}/bin" ]] && PATH="${HOME}/bin:${PATH}"

  # Setup custom Go install if present
  [ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin
  export GOPATH=$HOME/go
  [[ -d "${GOPATH}/bin" ]] && export PATH=$PATH:$GOPATH/bin
  # Enable golangci-lint bash completiong if installed
  if command -v golangci-lint &> /dev/null; then source <(golangci-lint completion bash); fi

  # FIXME: plenv shims configure and messes up nokogiri; disable until its been troublshot
  # Setup plenv
  #export PLENV_ROOT=/usr/local/var/plenv
  #if which plenv > /dev/null; then eval "$(plenv init -)"; fi

  # Setup pyenv
  export PYENV_ROOT=/usr/local/var/pyenv
  if which pyenv &> /dev/null; then eval "$(pyenv init -)"; fi

  # Setup poetry if installed
  export PATH="$HOME/.poetry/bin:$PATH"

  # Setup nvm and avn
  export NVM_DIR=~/.nvm
  if [ -s "$NVM_DIR/nvm.sh" ]; then # Linux
    source "$NVM_DIR/nvm.sh"
  elif which brew &> /dev/null && brew ls --versions nvm &> /dev/null; then # OSX
    source $(brew --prefix nvm)/nvm.sh
  fi
  [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
  [[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

  # Try to setup RVM first
  if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
    # TODO: Add in system-wide rvm check next
  # Setup rbenv
  elif which rbenv &> /dev/null; then
    eval "$(rbenv init -)"
  elif [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    export RBENV_ROOT="$HOME/.rbenv"
    eval "$(rbenv init -)"
  elif [ -d /usr/local/var/rbenv ]; then
    export RBENV_ROOT=/usr/local/var/rbenv
    eval "$(rbenv init -)"
  fi

  # If hub is installed, use over git
  if which hub &> /dev/null; then eval "$(hub alias -s)"; fi

  # Set our prompt to have RVM and GIT information
  RED="\[\033[0;31m\]"
  YELLOW="\[\033[0;33m\]"
  GREEN="\[\033[0;32m\]"
  BLUE="\[\033[1;34m\]"
  NO_COLOUR="\[\033[0m\]"
  #PS1="$BLUE[$GREEN\$(~/.rvm/bin/rvm-prompt),\$(parse_git_branch)$BLUE] \h:\W$NO_COLOUR "
  #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  #PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
  PS1_PREFIX="\D{%H:%M:%S} ${debian_chroot:+($debian_chroot)}$GREEN\u@\h$NO_COLOUR:$BLUE\w$NO_COLOUR"
  # If we have rvm or rbenv add in that information
  if [ -f ~/.rvm/bin/rvm-prompt ]; then
    PS1_RUBY=" (ruby:\$(~/.rvm/bin/rvm-prompt))"
  elif [ -f /usr/local/rvm/bin/rvm-prompt ]; then
    PS1_RUBY=" (ruby:\$(/usr/local/rvm/bin/rvm-prompt))"
  elif which rbenv &> /dev/null; then
    PS1_RUBY=" (ruby:\$(rbenv version-name))"
  else
    PS1_RUBY=""
  fi
  # If we have nvm call use, and add in the info
  if nvm 'current' &> /dev/null; then
    PS1_NODE=" (node:\$(nvm 'current'))"
  else
    PS1_NODE=""
  fi
  # If we have pyenv add in that information
  if which pyenv &> /dev/null; then
    PS1_PYTHON=" (python:\$(pyenv version-name))"
  else
    PS1_PYTHON=""
  fi
  # virtualenv and virtualenvwrapper
  if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    source /usr/local/bin/virtualenvwrapper.sh
  fi

  # If we have plenv add in that information
  if which plenv &> /dev/null; then
    PS1_PERL=" (perl:\$(plenv version-name))"
  else
    PS1_PERL=""
  fi
  # If we have __git_ps1 then add in that information
  if type __git_ps1 >/dev/null 2>&1; then
    PS1_GIT="\$(__git_ps1 ' (%s)')"
  else
    PS1_GIT=""
  fi

  # Combine all the sub-parts
  PS1="$PS1_PREFIX$PS1_RUBY$PS1_NODE$PS1_PYTHON$PS1_PERL$PS1_GIT\n\$ "

  # Configure git status for __git_ps1
  GIT_PS1_SHOWDIRTYSTATE=1
  #GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_SHOWSTASHSTATE=1

  # If terraform is installed add to path
  if [ -e /jcdata-source/terraform ]; then export PATH="$PATH:/jcdata-source/terraform"; fi

  # Export EC2 stuff
  export EC2_HOME=$HOME/ec2-api-tools-1.3-57419
  [ -f $EC2_HOME/bin ] && export PATH=$PATH:$EC2_HOME/bin
  export EC2_PRIVATE_KEY=$HOME/.ec2/pk-$KEY_ID.pem
  export EC2_CERT=$HOME/.ec2/cert-$KEY_ID.pem
  export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/

  # Setup GCE tools
  [ -f "$HOME/google-cloud-sdk/path.bash.inc" ] && source "$HOME/google-cloud-sdk/path.bash.inc"
  [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ] && source "$HOME/google-cloud-sdk/completion.bash.inc"
  if which kubectl > /dev/null; then source <(kubectl completion bash); fi

  # Setup ROS if present
  [ -f /opt/ros/jade/setup.bash ] && source /opt/ros/jade/setup.bash
  [ -f ./devel/setup.bash ] && source ./devel/setup.bash

  # Setup travis CLI bash extensions if present
  [ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
fi # if [[ -n "$PS1" ]]; then
