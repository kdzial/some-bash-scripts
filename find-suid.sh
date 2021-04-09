#!/bin/bash

# Script find-suid which searching all files and scripts which have setuid attribute and checking whether 
# it's possible to do some changes in him. Names are display in clear format.

mtime="7" # period of time backwards in which was did changes in checked files
verbose=0

if [ "$1" = "-v" ] ; then
 verbose=1 
fi

# find-perm finding files with specific permissions
# 4000 code or higher indicates setting setuid attribute

find /mnt/e -type f -perm /4000 -print0 | while read -d '' -r match
do 
  if [ -x "$match" ] ; then

# Excluding from results of "ls -ld" command information about owner of file and permission

    owner="$(ls -ld $match | awk '{print $3}')"
    perms="$(ls -ld $match | cut -c5-10 | grep 'w')"

    if [ ! -z $perms ] ; then
      echo "**** $match (permission for write, setuid attribute $owner)"
    elif [ ! -z $(find $match -mtime -$mtime -print) ] ; then
      echo "**** $match (changing $mtime days ago, setuid attribute $owner)"
    elif [ $verbose -eq 1 ] ; then

# By default displays just the dangerous scripts
# If you use -v displays all names

      lastmod ="$(ls -ld $match | awk '{print $6, $7, $8}')"
      echo "      $match (setuid attribute $owner, last modyfication: $lastmod)"
    fi
 fi
done

exit 0
