#!/bin/bash

function displaytime {
  local T=$(($1/1000))
  local H=$((T/60/60))
  local M=$((T/60%60))
  local S=$((T%60))
  local MS=$(($1%1000))
  (( $H > 0 )) && printf '%dh ' $H
  (( $M > 0 || $H > 0 )) && printf '%dm ' $M
  (( $S > 0 || $M > 0 || $H > 0 )) && printf '%d.%03ds' $S $MS
  (( $H == 0 && $M == 0 && $S == 0 )) && printf '%dms\n' $MS
}

function printRiddle {
  riddle=$1
  printf "%11s: " $riddle
  if prolog -q -l $riddle -t "['lib/solve.prolog'],verifyTest"; then
    startTime=$(date +%s%0N)
    prolog -q -l $riddle -t "['lib/solve.prolog'],printResultWithoutTest"
    endTime=$(date +%s%0N)
    duration=$(( ($endTime-$startTime)/1000000 ))
    echo "$RESULT ($(displaytime $duration))"
  else
    echo
  fi
}

for riddle in $(ls $1*.prolog | grep -v debug | sort -V); do
  printRiddle $riddle
done
