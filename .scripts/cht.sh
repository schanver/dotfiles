#!/usr/bin/env bash 

languages=`echo "haskell lua nodejs cpp c java kotlin python" | tr ' ' '\n'`
core_utils=`echo "xargs find mv sed awk" | tr ' ' '\n'`

selected=$(printf "%s\n" "$languages" "$core_utils" | fzf)
read -p "query: " query

if printf "%s\n" "$languages" | grep -qsF -- "$selected"; then 
  curl -s "cht.sh/$selected/$(echo "$query" | tr ' ' '+')" > /tmp/file && bat /tmp/file
else 
  curl -s "cht.sh/$selected~$query"
fi
