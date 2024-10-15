#!/bin/bash

getChoice() {
  {
    local prompt=${1}
    shift

    echo
    printf '%s\0' "$@" | xargs -0 -n 1 basename | nl -s ': '
    echo

    local choice=0
    while [[ ! ${choice} =~ ^[0-9]+$ ]] || (( choice < 1 || choice > $# )) ; do
      read -re -p "${prompt}: " choice
    done

    return $(( choice - 1 ))
  } >&2
}

backup(){
  file=$1

  if [ -e $file ]; then
    backup_target="$file.bak"

    attempt=1
    while [[ -e $backup_target ]]; do
      attempt=$((attempt+1))

      new_backup_target="$file.bak$attempt"
      echo "$backup_target already exists, trying $new_backup_target..."
      backup_target=$new_backup_target
    done

    cp -r $file $backup_target
    echo "Backed up $file to $backup_target."
  else
    echo "Target $file is not a file"
    false
  fi
}

restore(){
  file=$1

  if [ -e $file ]; then
    if [[ $file =~ (.*)\.bak([0-9]+)?$ ]]; then
      basefile=$(echo "${BASH_REMATCH[1]}")
      backup=$file
    else
      basefile=$file

      backups=( ${basefile}.bak* )

      if [ -z "$(find . -maxdepth 1 -type f -name "${basefile}.bak*" 2>/dev/null)" ]; then
        echo "No backups of ${file} found."
        exit 1
      else
        getChoice "Choose a backup to restore" "${backups[@]}"
        backup=${backups[$?]}
      fi
    fi

    filepattern="$basefile.bak*"

    read -p "This will overwrite $basefile and $(ls $filepattern | wc -l | xargs) backup file(s). Continue? ([Y]es/[N]o/[K]eep backup) " -r

    if [[ $REPLY == [yY] ]]; then
      rm -r $basefile
      mv $backup $basefile
    elif [[ $REPLY == [kK] ]]; then
      rm -r $basefile
      cp -r $backup $basefile
    fi

    if [[ $REPLY == [yY] ]]; then
      rm -f $filepattern
    fi
  else
    echo "$file is not a backup"
  fi
}

if [ $1 = "restore" ]; then
  restore "${@:2}"
elif [ $1 = "create" ]; then
  backup "${@:2}"
else
  backup "$@"
fi
