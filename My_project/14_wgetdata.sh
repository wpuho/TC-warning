#! /bin/sh

######### SST data ##########

echo ' '
while read -p ' SST data is '"$sst"', do you want to continue ? [y/n] ' option
do

if [ $option = y ]; then

  echo ' '
  wget --ftp-user=wpuhoo@gmail.com --ftp-password=wpuhoo@gmail.com 'ftp://ftp.remss.com/sst/daily/mw/v05.0/netcdf/rt/'$sst'120000-REMSS-L4_GHRSST-SSTfnd-MW_OI-GLOB-v02.0-fv05.0-rt.nc'
  return_sst=$?

  if [ $return_sst -eq 0 ]; then

    echo ' ' 
    echo ' Successfully downloaded SST data !! '
    echo ' ' 
    echo '======================================================================='
    break

  else

    echo ' ' 
    echo ' Failed to download SST data. No such file or directory. '
    echo ' ' 
    echo '======================================================================='
    break

  fi

elif [ $option = n ]; then

  echo ' ' 
  echo ' Stop downloading SST data ...'
  echo ' ' 
  echo '======================================================================='
#  exit 1
  break

else

  echo ' ' 
  echo 'Try again, please input [y/n]'
  echo ' ' 
  echo '======================================================================='

fi

done

######### TC track ##########

echo ' '
while read -p ' TC warning file is '"$track"', do you want to continue ? [y/n] ' option
do

if [ $option = y ]; then

  echo ' '
  wget 'https://www.metoc.navy.mil/jtwc/products/'$track
  return_track=$?

  if [ $return_track -eq 0 ]; then

    echo ' ' 
    echo ' Successfully downloaded TC warning file !! '
    echo ' ' 
    echo '======================================================================='
    break

  else

    echo ' ' 
    echo ' Failed to download TC warning file. No such file or directory. '
    echo ' ' 
    echo '======================================================================='
    break

  fi

elif [ $option = n ]; then

  echo ' ' 
  echo ' Stop downloading TC warning file ...'
  echo ' ' 
  echo '======================================================================='
  exit 1

else

  echo ' ' 
  echo 'Try again, please input [y/n]'
  echo ' ' 
  echo '======================================================================='

fi

done
