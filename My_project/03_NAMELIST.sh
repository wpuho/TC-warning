#! /bin/sh

echo `awk 'BEGIN{FS=","} NR==11{print substr($1,13,length-12-2)}' 02_namelist.input` > tmp.txt    # OISST.nc  		nml_1

echo `awk 'BEGIN{FS=","} NR==17{print substr($1,16,length-15-2)}' 02_namelist.input` >> tmp.txt    # input tcw
echo `awk 'BEGIN{FS=","} NR==18{print substr($1,14,length-13-2)}' 02_namelist.input` >> tmp.txt    # label for previous
echo `awk 'BEGIN{FS=","} NR==19{print substr($1,14,length-13-2)}' 02_namelist.input` >> tmp.txt    # label for forcast
echo `awk 'BEGIN{FS=","} NR==23{print substr($1,15,length-14-2)}' 02_namelist.input` >> tmp.txt    # output		 nml_5

echo `awk 'BEGIN{FS=","} NR==22{print substr($1,15,length-14-2)}' 02_namelist.input` >> tmp.txt    # filename
echo `awk 'BEGIN{FS=","} NR==23{print substr($1,15,length-14-2)}' 02_namelist.input` >> tmp.txt    # filename2
echo `awk 'BEGIN{FS=","} NR==24{print substr($1,15,length-14-2)}' 02_namelist.input` >> tmp.txt    # psname
echo `awk 'BEGIN{FS=","} NR==25{print substr($1,11,length-10-2)}' 02_namelist.input` >> tmp.txt    # TC type
echo `awk 'BEGIN{FS=","} NR==26{print substr($1,9,length-8-2)}' 02_namelist.input` >> tmp.txt      # TC No			  nml_10
echo `awk 'BEGIN{FS=","} NR==27{print substr($1,11,length-10-2)}' 02_namelist.input` >> tmp.txt    # TC name
echo `awk 'BEGIN{FS=","} NR==28{print substr($1,14,length-13-2)}' 02_namelist.input` >> tmp.txt    # Warning
echo `awk 'BEGIN{FS=","} NR==14{print substr($1,12,length-11-2)}' 02_namelist.input` >> tmp.txt    # SST data

exit 0
#echo $input > npipe
#echo $output > npipe

#./test.sh
