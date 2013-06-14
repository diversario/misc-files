#!/bin/bash

function checkout_branches() {
  local cwd=`pwd`
  local branch
  [ $1 ] && branch=$1 || branch=''
  
  local files=`ls $cwd`
  
  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      
      if [ `git status 2>&1 | grep "fatal" | wc -l` == 0 ]; then
        if [ "${branch}" == "" ]; then
          local latest=`git branch -a | grep -o release.\*$ | sort | tail -r | uniq | head -n 1`
          echo "$file: latest is $latest";
          git checkout $latest;
        else
          git checkout $branch;
        fi
      fi
      
    fi
  done
}

checkout_branches "$@"