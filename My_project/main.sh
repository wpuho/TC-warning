#! /bin/sh

#./WGETDATA.sh

#val=$?
#if [ $val -eq 1 ]; then
#  exit 0
#fi

./GETSST.sh

./TRACK.sh

val=$?
if [ $val -ne 1 ]; then
  rm 'tmp.txt'
  exit 0
fi

./PLOT.sh

results=`awk 'NR==14{print substr($1,11,length-11-2)}' namelist.input`
results=$results'.*'

mv *.png result/
mv $results result/
mv *.txt result/
