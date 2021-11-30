#!/bin/bash
#print the options
usage () {
  echo ""
  echo "bracken-filter-reads filters low abundant reads from Bracken outputs"
  echo ""
  echo "Usage example: bracken-filter-reads -n 1000 -o NEW-OUTPUT BRACKEN-OUTPUT-TABLE"
  echo ""
  echo "Options:"
  echo " -n Lowest threshold for filtering reads (default:1000)"
  echo " -o New output name (default: OLDFILENAME-filtered)"
  echo " -h Print usage and exit"
  echo " -v Print version and exit"
  echo ""
  echo "Version 0.2 (2021)"
  echo "Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk"
  echo "";
}

version (){
echo "bracken-filter-reads version 0.2"
}

# default value for threshold

THRESHOLD=1000
OUTPUT=EMPTY

# Call options
while getopts 'n:o:hv' opt;do
  case $opt in
    n) THRESHOLD=$OPTARG;;
    o) OUTPUT=$OPTARG;;
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

if [ -e "$FILE" ] && [ "$OUTPUT" == "EMPTY" ]

then
# remove column of taxonomy_id, taxonomy_lvl and _frac (relative abundance we only want reads)
awk -F "\t" -v FS='\t' -v OFS='\t' 'NR==1{for (i=1;i<=NF;i++)if ($i=="taxonomy_id"){n=i-1;m=NF-(i==NF)}} {for(i=1;i<=NF;i+=1+(i==n))printf "%s%s",$i,i==m?ORS:OFS}' OFS='\t' $FILE |
awk -F "\t" -v FS='\t' -v OFS='\t'  'NR==1{for (i=1;i<=NF;i++)if ($i=="taxonomy_lvl"){n=i-1;m=NF-(i==NF)}} {for(i=1;i<=NF;i+=1+(i==n))printf "%s%s",$i,i==m?ORS:OFS}' OFS='\t'|
awk -F "\t"  '{ for (i=3;i<=NF;i+=2) $i="" }1' OFS='\t'|
awk -F "\t" -v var=$THRESHOLD 'NR==1; NR > 1{for(i=2; i <= NF; i++) if($i >= var) {print; next}}' OFS='\t'|
# remove empty column with sed
sed 's/\t\+/\t/g;s/^\t//'> $FILE-filtered

else
    if [ -e "$FILE" ]
    then
    awk -F "\t" -v FS='\t' -v OFS='\t' 'NR==1{for (i=1;i<=NF;i++)if ($i=="taxonomy_id"){n=i-1;m=NF-(i==NF)}} {for(i=1;i<=NF;i+=1+(i==n))printf "%s%s",$i,i==m?ORS:OFS}' OFS='\t' $FILE |
awk -F "\t" -v FS='\t' -v OFS='\t'  'NR==1{for (i=1;i<=NF;i++)if ($i=="taxonomy_lvl"){n=i-1;m=NF-(i==NF)}} {for(i=1;i<=NF;i+=1+(i==n))printf "%s%s",$i,i==m?ORS:OFS}' OFS='\t'|
awk -F "\t"  '{ for (i=3;i<=NF;i+=2) $i="" }1' OFS='\t'|
awk -F "\t" -v var=$THRESHOLD 'NR==1; NR > 1{for(i=2; i <= NF; i++) if($i >= var) {print; next}}' OFS='\t'|
# remove empty column with sed
sed 's/\t\+/\t/g;s/^\t//'> $OUTPUT

    else 
        echo "$FILE file does not seem to exist. Program will now exit."
        exit 1
    fi
fi
