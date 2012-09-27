#!/bin/bash

function checkRepos() {
  local cwd=$1
  local files=`ls $cwd`
  local commits="^##\ .+\ \[ahead [0-9]+\]$"
  local changes="^\ *([MADCUR\?]{1,2})\ .+$"

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      local status=`git status -bs 2>/dev/null`

      if [ `echo "${status}" | grep -E "${commits}" | wc -l` != 0 ]; then
        echo -e "\E[33;1m$file\E[0m has local commits.";
      fi
      
      if [ `echo "${status}" | grep -E "${changes}" | wc -l` != 0 ]; then
        echo -e "\E[31;1m$file\E[0m has changes.";

        #for line in "${status}"; do 
        #  [[ "${line}" =~ \ *([MADCUR\?]{1,2})\ .+ ]]
        #  echo "${BASH_REMATCH[1]}"
        #done
        
      fi
      
      if [ "${status}" == "" ]; then
        cd ..
      fi
    fi
  done
}

checkRepos `pwd`