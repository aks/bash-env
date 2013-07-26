# Alan's bashrc

# only do this if interactive shell

if [[ -n "$PS1" ]]; then

  for d in ~ ~aks ; do
    if [[ -f $d/.environment.sh ]]; then
      export RCHOME=$d
      break
    fi
  done

  # make sure we have a good bash (version >= 3)
  [[ -f $RCHOME/.bashrc.good-bash.sh ]] && source $RCHOME/.bashrc.good-bash.sh

  # source our environment
  [[ -f $RCHOME/.environment.sh ]] && source $RCHOME/.environment.sh

  # load RVM into the shell session
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

fi
# vim: sw=2 ai

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
