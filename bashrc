# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# Changed for rvm
#[ -z "$PS1" ] && return
if [[ -n "$PS1" ]] ; then

  # don't put duplicate lines in the history. See bash(1) for more options
  # ... or force ignoredups and ignorespace
  HISTCONTROL=ignoredups:ignorespace

  # append to the history file, don't overwrite it
  shopt -s histappend

  # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
  HISTSIZE=1000
  HISTFILESIZE=2000

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

  # enable programmable completion features (you don't need to enable
  # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
  # sources /etc/bash.bashrc).
  if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
      source /etc/bash_completion
  fi

  # Include bash completion for OSX with brew
  if [ -x brew ]; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
      source `brew --prefix`/etc/bash_completion
    fi
  fi

  # Add GIT completion scripts
  #. ~/.git-completion.sh
  if [ -f $HOME/.git/git-flow-completion.sh ]; then
    source $HOME/.git/git-flow-completion.sh
  fi
  if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    source /usr/local/etc/bash_completion.d/git-completion.bash
  fi
  if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    source /usr/local/etc/bash_completion.d/git-prompt.sh
  fi

  # Add hub completion scripts
  source ~/.hub.bash_completion.sh

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
  elif [ `which rbenv` ]; then
    PS1_RUBY=" (ruby:\$(rbenv version-name))"
  else
    PS1_RUBY=""
  fi
  # If we have pyenv add in that information
  if [ `which pyenv` ]; then
    PS1_PYTHON=" (python:\$(pyenv version-name))"
  else
    PS1_PYTHON=""
  fi
  # If we have plenv add in that information
  if [ `which plenv` ]; then
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
  PS1="$PS1_PREFIX$PS1_RUBY$PS1_PYTHON$PS1_PERL$PS1_GIT\n\$ "

  # Configure git status for __git_ps1
  GIT_PS1_SHOWDIRTYSTATE=1
  #GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_SHOWSTASHSTATE=1

  # Add my bin to path
  export PATH=$PATH:~/bin

  # Configure some Python stuff
  #export PATH=/usr/local/share/python:$PATH
  #export PIP_REQUIRE_VIRTUALENV=true
  #export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

  # Setup Go root
  export GOPATH=$HOME/.gopath
  export PATH=$PATH:$GOPATH/bin

  # Prepend local/bin for rbenv to override things like git
  # and local/sbin for homebrew
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH

  # Export EC2 stuff
  export EC2_HOME=$HOME/ec2-api-tools-1.3-57419
  [ -f $EC2_HOME/bin ] && export PATH=$PATH:$EC2_HOME/bin
  export EC2_PRIVATE_KEY=$HOME/.ec2/pk-$KEY_ID.pem
  export EC2_CERT=$HOME/.ec2/cert-$KEY_ID.pem
  export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/

  # Add ssh key to ssh agent if not added
  ssh-add -l &> /dev/null || ssh-add &> /dev/null

fi # if [[ -n "$PS1" ]]; then

# This is a good place to source rvm v v v
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# Setup rbenv as well
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Setup pyenv
export PYENV_ROOT=/usr/local/var/pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Setup plenv
export PLENV_ROOT=/usr/local/var/plenv
if which plenv > /dev/null; then eval "$(plenv init -)"; fi
