#!/bin/bash
echo "========================================================================="
echo "| gccWarninsCount - Count and list warnings from gcc compilation output |"
echo "| Usage: sh warningsCount.sh PROJECT_PATH MODE                          |"
echo "| mode: silent(defaul) or verbose                                       |"
echo "========================================================================="

if [ "$#"  -lt 1 ]
then
  echo Wrong number of arguments
  echo Usage: $0 \<PROJECT_PATH\>
  echo PROJECT_PATH - Path of project to build
  exit 1
else
  # Go to project to build
  cd $1
  ## Output mode
  if [ "$#" -gt "1" ]
  then
    echo "Verbose Build. Project PATH:"
    echo $1
    BUILD_OPTIONS="--v"
  else
    echo "Silent build. Project PATH:"
    echo $1
    BUILD_OPTIONS="--silent"
  fi
  echo "=========================== CLEAN BUILD ==============================="
  make clean $BUILD_OPTIONS
  echo "=========================== BUILD STARTED ============================="
  make $BUILD_OPTIONS 2> build.log

  echo "\n======================== WARNINGS LIST ================" > output.log
  grep "warning:" build.log \
    | awk '{print $0}{total+=1}END{print "Total warnings:\n"total}' \
    >> output.log

  grep "warning:" build.log \
    | awk '{total+=1}END{print "Total number of warnings:\n"total}'

  echo "\n====================== QNIQUE WARNINGS LIST ===========" > output.log
    grep "warning:" build.log | sort | uniq -c | sort -nr \
    | awk '{print $0}{total+=1}END{print "Total unique warnings:\n"total}' \
    >> output.log

  grep "warning:" build.log | sort | uniq -c | sort -nr \
    | awk '{total+=1}END{print "Total number of unique warnings:\n"total}'
  echo "======================================================================="
  echo "|     Build output in the file : build.log                            |"
  echo "|     Warnings list in the file : output.log                          |"
  # Return to script folder
  echo "Return to script folder:"
  cd -
  echo "======================================================================="
fi
