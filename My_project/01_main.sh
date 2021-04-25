#! /bin/sh

#./WGETDATA.sh

#val=$?
#if [ $val -eq 1 ]; then
#  exit 0
#fi

./06_GETSST.sh

./09_TRACK.sh

val=$?
if [ $val -ne 1 ]; then
  rm 'tmp.txt'
  exit 0
fi

./11_PLOT.sh

results=`awk 'NR==14{print substr($1,11,length-11-2)}' 02_namelist.input`
results=$results'.*'

mv *.png result/
mv $results result/
mv *.txt result/
