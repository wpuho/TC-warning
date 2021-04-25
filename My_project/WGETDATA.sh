#! /bin/sh

export file=tmp.txt
rm $file
touch $file

./NAMELIST.sh

filein=1
while read line
do
    export 'nml_'$filein=$line 
    filein=`expr $filein + 1`
done < $file

rm $file

#export OISST=$nml_1
export input=$nml_2
#export lb_prvs=$nml_3
#export lb_fcst=$nml_4
#export output=$nml_5
#export filename=$nml_6
#export filename2=$nml_7
#export psname=$nml_8
#export TC_type=$nml_9
#export TC_No=$nml_10
#export TC_name=$nml_11
#export Warning=$nml_12
export SST_plot=$nml_13

export track=`echo $input | cut -c 1-6,12-15`
export sst=`echo $SST_plot | cut -c 1-10`

./wgetdata.sh

return=$?

if [ $return -eq 0 ]; then
exit 0
elif [ $return -eq 1 ]; then
exit 1
fi
