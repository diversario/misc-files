#!/bin/bash

GREEN="\033[0;32m"
NO_COLOR="\033[0m"

function listBranches() {
  local cwd=$1
  local files=`ls $cwd`

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      
      if [ `git status 2>&1 | grep "fatal" | wc -l` == 0 ]; then
        local branch=`git branch | grep ^\* | sed 's/*\ \(.*\)/\1/'`;
        
        echo -n $file":$branch" | awk -v green="$GREEN" -v no_color="$NO_COLOR" -F":" '{ printf "%-30s %-20s\n", $1, green $2 no_color}'
        
      fi
      
      cd ..;
    fi
  done
}

while getopts ":c" opt; do
  case $opt in
  
    c ) listBranches `pwd` | perl -pe 's/\e\[?.*?[\@-~]//g'
      exit;;
    * ) echo -e "Usage: list_branches [-c]\n\nOptions:\n\t-c\t Disable colored output. Useful if script output is to be used as input."
      exit;;
  esac
done

listBranches `pwd`