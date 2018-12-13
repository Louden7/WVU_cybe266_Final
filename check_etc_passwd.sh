#!/bin/bash

while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
do
  if(($f3 == '0'))
    then
    string="$string$f1:$f2:$f3:$f4:$f5:$f6:$f7\n"
  fi

  if(($f3 < '1000'))
    then
    if grep -q "nologin" <<< $f7
        then
        a="temp"
    elif grep -q "false" <<< $f7
        then
        b="temp"
    else
        shell="$shell$f1:$f2:$f3:$f4:$f5:$f6:$f7\n"
      fi
    fi
  done <"/etc/passwd"
  echo -e "Root Users:\n$string\n"
  echo -e "Active Shells:\n$shell\n"
