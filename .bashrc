# Alan's bashrc

# only do this if interactive shell

if [[ -n "$PS1" ]]; then

  for d in ~ ~aks ; do
    if [[ -f $d/.environment.sh ]]; then
      export RCHOME=$d
      break
    fi
  done

  # source our environment
  [[ -f $RCHOME/.environment.sh ]] && source $RCHOME/.environment.sh

fi
# vim: sw=2 ai
