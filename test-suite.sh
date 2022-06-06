#!/bin/bash -x

HD=/home/happyuser
BKD=/mnt/backup

mkdir -p $HD
mkdir -p $BKD
touch --date="1999-11-29 13:55" $HD/file1

./srbackup.sh $HD $BKD

ls -la $HD
ls -la $BKD

if [ "$(stat -c %x $HD/file1)" == "$(stat -c %x $BKD/happyuser/file1)" ]; then
  echo OK
else
  echo ERROR
fi

if [ "$(stat -c %y $HD/file1)" == "$(stat -c %y $BKD/happyuser/file1)" ]; then
  echo OK
else
  echo ERROR
fi
