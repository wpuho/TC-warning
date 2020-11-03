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

export OISST=$nml_1
#export input=$nml_2
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

echo $input

cp *.nc $OISST
#cp $OISST $OISST'.nc'
#rm $OISST

gfortran getsst.f90 -o getsst `nf-config --fflags --flibs`

./getsst

echo ' '
echo $SST_plot'.txt and '$SST_plot'.mask successfully generated !!'

rm $OISST
rm getsst
