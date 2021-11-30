#!/bin/bash
#print the options
usage () {
  echo ""
  echo "bracken-filter-reads filters low abundant reads from Bracken outputs"
  echo ""
  echo "Usage example: bracken-filter-reads -n 1000 BRACKEN-OUTPUT"
  echo ""
  echo "Options:"
  echo " -n Lowest threshold for filtering reads (default:1000)"
  echo " -h Print usage and exit"
  echo " -v Print version and exit"
  echo ""
  echo "Version 0.1 (2021)"
  echo "Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk"
  echo "";
}

version (){
echo "bracken-filter-reads version 0.1"
}


# default value for threshold
THRESHOLD=1000

# Call options
while getopts 'n:hv' opt;do
  case $opt in
    n) THRESHOLD=$OPTARG;;
    h) usage; exit;;
    v) version; exit;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
   esac
done

# Skip over processed options
shift $((OPTIND-1))
# check for mandatory positional parameters, only 1 positional argument will be checked
if [ $# -lt 1 ]; then
   echo "Missing optional argument or positional argument"
   echo ""
   echo "Options: ./bracken-filter-reads -h"
   echo ""
   echo ""
   exit 1
fi

# Here script starts:
FILE=$1

if [ -e "$FILE" ]
then

awk -v var=$THRESHOLD 'NR==1; NR > 1{for(i=2; i <= NF; i++) if($i >= var) {print; next}}' $FILE > $FILE-filtered

else
    echo "$FILE file does not seem to exist. Program will now exit."
    exit 1
fi
