#!/bin/bash

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
        echo -e "\E[33;1m$file\E[0m has local commits.";
      fi
      
      if [ `echo "${status}" | grep -E "${changes}" | wc -l` != 0 ]; then
        echo -en "\E[31;1m$file\E[0m has changes:";

        local statuses='';
                
        while read -r line; do
          [[ "${line}" =~ \ *([CAR\?MUD\!]{1,2})\ .+ ]]
          statuses="${statuses} ${BASH_REMATCH[1]}" 
        done <<< "${status}"
        
        echo "${statuses}" | sed 's/ /\n/g' | sort | uniq | tr "\\n" " " # get all unique status values
        echo ""
        #statuses="`echo "${statuses}" | sed 's/ /\n/g' | sort | uniq`" # get all unique status values
        #statuses="`echo "${statuses}" | sed 's/ /\n/g'`" # line per status
        
        #local repoStatus='';
        
        #while read -r line; do
        #  [[ "${line}" =~ ([CAR\?MUD\!])+ ]]
        #  local s="${BASH_REMATCH[1]}";
        #  
        #  case $s in
        #    A) echo -n "added ";;
        #    M) echo -n "modified ";;
        #    D) echo -n "deleted ";;
        #    R) echo -n "renamed ";;
        #    C) echo -n "copied ";;
        #    U) echo -n "updated ";;
        #    ?) echo -n "untracked ";;
        #  esac
        #done <<< "${statuses}"
        #
        #echo "";
      fi
      
      if [ "${status}" == "" ]; then
        cd ..
      fi
    fi
  done
}

checkRepos `pwd`