#!/bin/bash

function checkRepos() {
  local cwd=$1
  local files=`ls $cwd`

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      local status=`git status -bs 2>/dev/null`

      if [ `echo "${status}" | grep -E "^##\s.+\s\[ahead [0-9]+\]$" | wc -l` != 0 ]; then
        echo -e "\E[33;1m$file\E[0m has local commits.";
      fi
      
      if [ `echo "${status}" | grep -E "^\s*[MADCUR\?]{1,2}\s.+$" | wc -l` != 0 ]; then
        echo -e "\E[31;1m$file\E[0m has changes.";
      fi
      
      if [ "${status}" == "" ]; then
        cd ..
      fi
    fi
  done
}

checkRepos `pwd`