# n:  `node [nodefile] [args]'
n ( ) {
  if [[ "${1%.js}" != "$1" && -f "$1" ]]    # `node nodefile.js args'
     then export NODEFILE="$1"
          shift
          node "$NODEFILE" "$@"
  elif [[ -f "$1.js" ]]                     # `node nodefile args'
     then export NODEFILE="$1.js"
          shift
          node "$NODEFILE" "$@"
     else node "$NODEFILE" "$@"             # `node args'
  fi
  return
  }
