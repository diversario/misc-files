#!/bin/bash

function pullRepos() {
  local cwd=$1
  local files=`ls $cwd`
  local commits="^##\ .+\ \[ahead [0-9]+\]$"
  local changes="^\ *([CAR\?MUD\!]{1,2})\ .+$"

  for file in $files; do
    if [ -d $cwd/$file ]; then
      cd $cwd/$file;
      git remote show origin 2>/dev/null | grep "Fetch" | grep -o "[A-Za-z0-9\.-]*\.git" 
      git pull 2>/dev/null;
    fi
  done
}

pullRepos `pwd`
