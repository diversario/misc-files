#!/bin/bash

YELLOW="\033[0;33m"
RED="\033[0;31m"
NO_COLOR="\033[0m"

function pullRepos() {
  local cwd=$1
  local files=`ls $cwd`
  local commits="^##\ .+\ \[ahead [0-9]+\]$"
  local changes="^\ *([CAR\?MUD\!]{1,2})\ .+$"

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      
      git remote show origin 2>/dev/null | grep "Fetch" | grep -o "[A-Za-z0-9\.-]*\.git"
      local output=`git pull 2>&1`;# 2>/dev/null;
      
      if [[ $output =~ "Fast-forward" ]] ; then
        echo -e "$output";
        
      elif [[ $output =~ "specify which branch" ]] ; then
        echo -e "$RED Could not pull: no branch specified.$NO_COLOR";
        echo;
      
      elif [[ $output =~ "Aborting" ]] ; then
        echo -e "$RED Could not pull: uncommitted local changes.$NO_COLOR";
        echo;
      
      elif [[ $output =~ "refused" ]] ; then
        echo -e "$RED Could not pull: Connection error.$NO_COLOR";
        echo;
      fi

    fi
  done
}

pullRepos `pwd`
