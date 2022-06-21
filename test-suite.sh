#!/bin/bash

HD=/home/happyuser
BKD=/mnt/backup
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BUILD_SUCCESSFUL=true

function before() {
  echo -e "\nRunning tests"
  mkdir -p $HD
  mkdir -p $BKD/happyuser
  touch --date="1997-11-29 13:55" $HD/file1
  touch $HD/file2
  touch --date="1998-11-29 13:56" $BKD/happyuser/file2
  touch --date="1999-11-29 13:57" $BKD/happyuser/file3
}

function test_srbackup() {
  ./srbackup.sh $HD $BKD
  assert_result
}

function test_help() {
  OUTPUT=$(./srbackup.sh --help)
  assert_help_result "$OUTPUT" "help"
}

function test_h() {
  OUTPUT=$(./srbackup.sh -h)
  assert_help_result "$OUTPUT" "h"
}

function after() {
  if [ $BUILD_SUCCESSFUL == true ]; then
    echo -e "Build successful \n"
    exit 0
  else
    echo Build fail
    exit 1
  fi
}

function successful_assertion() {
  echo -e "[${GREEN}OK${NC}]" "$1"
}

function failure_assertion() {
  BUILD_SUCCESSFUL=false
  echo -e "[${RED}FAIL${NC}]" "$1"
}

function assert_access_time() {
  ASSERTION_NAME="Test access time."
  if [[ -e $BKD/happyuser/file1 && "$(stat -c %x $HD/file1)" == "$(stat -c %x $BKD/happyuser/file1)" ]]; then
    successful_assertion "$ASSERTION_NAME"
  else
    failure_assertion "$ASSERTION_NAME"
  fi
}

function assert_modify_time() {
  ASSERTION_NAME="Test modify time."
  if [[ -e $BKD/happyuser/file1 && "$(stat -c %y $HD/file1)" == "$(stat -c %y $BKD/happyuser/file1)" ]]; then
    successful_assertion "$ASSERTION_NAME"
  else
    failure_assertion "$ASSERTION_NAME"
  fi
}

function assert_override_modified_file() {
  ASSERTION_NAME="Test override modified file."
  if [[ -e $BKD/happyuser/file2 && "$(stat -c %y $HD/file2)" == "$(stat -c %y $BKD/happyuser/file2)" ]]; then
    successful_assertion "$ASSERTION_NAME"
  else
    failure_assertion "$ASSERTION_NAME"
  fi
}

function assert_non_existent_files_in_the_source() {
  ASSERTION_NAME="Test non-existent files in the source."
  if test -e $BKD/happyuser/file3 && grep -Pzq "Missing files:\nsending incremental file list\nhappyuser/file3" "$BKD/srbackup-missing.log" ; then
    successful_assertion "$ASSERTION_NAME"
  else
    failure_assertion "$ASSERTION_NAME"
  fi
}

function assert_result() {
  assert_access_time
  assert_modify_time
  assert_override_modified_file
  assert_non_existent_files_in_the_source
}

function assert_help_result() {
  ASSERTION_NAME="Test $2."
  if [ "$1" = "Usage: srbackup.sh <source dir> <target dir>" ]; then
    successful_assertion "$ASSERTION_NAME"
  else
    failure_assertion "$ASSERTION_NAME"
  fi
}

before
test_srbackup
test_help
test_h
after
