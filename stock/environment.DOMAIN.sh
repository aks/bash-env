# .envrionment.__DOMAIN__.sh  -- environment for __DOMAIN__ systems

export DOMAIN=__DOMAIN__
if [[ -z "$WORKGROUP" ]]; then
  export WORKGROUP="$DOMAIN"
fi


