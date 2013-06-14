#!/bin/bash

YELLOW="\033[0;33m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NO_COLOR="\033[0m"

function checkRepos() {
  local cwd=$1
  local files=`ls $cwd`
  local commits="^##\ .+\ \[ahead [0-9]+\]$"
  local changes="^\ *([CAR\?MUD\!]{1,2})\ .+$"

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      local status=`git status -bs 2>/dev/null`

      if [ `echo "${status}" | grep -E "${commits}" | wc -l` != 0 ]; then
        echo -e "$YELLOW$file$NO_COLOR has local commits.";
      fi
      
      if [ `echo "${status}" | grep -E "${changes}" | wc -l` != 0 ]; then
        echo -en "$RED$file$NO_COLOR has changes: ";

        local statuses='';
                
        while read -r line; do
          [[ "${line}" =~ \ *([CAR\?MUD\!]{1,2})\ .+ ]]
          statuses="${statuses} ${BASH_REMATCH[1]}" 
        done <<< "${status}"
        
        echo "${statuses}" | sed 's/ /\n/g' | sort | uniq | tr "\\n" " " # get all unique status values
        echo ""
      fi
      
      if [ "${status}" == "" ]; then
        cd ..
      fi
    fi
  done
}

checkRepos `pwd`
