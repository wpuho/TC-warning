#! /bin/sh

echo 'SST data    : '$filename'.txt' 
echo 'figure type : '$filename2 
echo 'output name : '$psname'.png' 
echo 'TC type     : '$TC_type 
echo 'TC number   : '$TC_No
echo 'TC name     : '$TC_name 
echo 'Warning No. : '$Warning 

if [ $SST_plot != $filename ]; then

  echo ' ' 
  echo "Warning : SST_INPUT_FILE and INPUT_FOR_PLOT are not consistent in namelist.input ."
  echo ' ' 

fi

while read -p 'Above are namelists, do you want to continue ? [y/n] ' option
do
echo ' ' 

  if [ $option = y ] || [ $option = n ]; then

    if [ $option = y ]; then

      echo 'Making the figure ...'

# ================ COLOR BAR ====================

      cptL=26
      cptR=32
      cint=0.1

      cinta=0.5
      cintf=1

# ================== plot basement ===============

      gmtset ANOT_FONT_SIZE 16
      gmtset HEADER_FONT_SIZE 24
      gmtset PLOT_DEGREE_FORMAT ddd:mm:ssF MEASURE_UNIT inch PAPER_MEDIA a0

      surface $filename'.txt' -Gdata.grd -I0.25 -R90.125/155.125/0.125/35.125 -T0 -Z1.7

      grdsample data.grd -I0.25 -R -Gdata.grd

      grdimage data.grd -R95/155/0/35 -JQ180/9 -C12_scale_SST.cpt -Y3.9 -X1 -K  >$psname.ps

      psxy $filename'.mask' -R -G100 -J -Ss0.06 -O -K  >>$psname.ps

      pscoast -J -R -G200 -W1 -Ba10f5/a5f5WeSn -Di -O -K  >>$psname.ps

      echo 152 36.4 17 0 28 6 $psname  >>temp2
      pstext temp2 -R -J -G255 -S10/0/0/0 -N -O -K  >>$psname.ps

      echo 141.5 38 15 0 28 6 $TC_type' '$TC_No' ('$TC_name') Warning #'$Warning  >>temp2
      pstext temp2 -R -J -G255 -S10/0/0/0 -N -O -K  >>$psname.ps

# ================== add track ==================

      psxy $filename2'_prvs.txt' -R -J -O  -W7/0/0/0 -O -K  >>$psname.ps
      psxy $filename2'_prvs.txt' -R -J -O  -C13_scale_TC.cpt -Sc0.12 -O -K  >>$psname.ps
      psxy $filename2'_prvs.txt' -R -J -O  -W4/0/0/0 -Sc0.13 -O -K  >>$psname.ps

      psxy $filename2'_fcst.txt' -R -J -O  -W7,0/0/0,-O -K  >>$psname.ps
      psxy $filename2'_fcst.txt' -R -J -O  -C13_scale_TC.cpt -Sc0.12 -O -K  >>$psname.ps
      psxy $filename2'_fcst.txt' -R -J -O  -W4,0/0/0,- -Sc0.13 -O -K  >>$psname.ps

      pstext $filename2'_prvs_label.txt' -R -J -G0/0/0 -S8/255/255/255 -O -K  >>$psname.ps

      pstext $filename2'_fcst_label.txt' -R -J -G0/0/0  -S8/255/255/5 -O -K  >>$psname.ps

      gmtset ANOT_FONT_SIZE 16
      gmtset LABEL_FONT_SIZE 16

      psscale -C12_scale_SST.cpt -D4.5/-0.5/9/0.1h -Ba$cintaf$cintf::/:"@+o@+C": -E -O -K  >>$psname.ps

      #echo 125.2 32.1 | psxy -R -J -Ss0.15 -W4 -G50/205/50 -O -K >>$psname.ps
      #echo 124.5 33.9 | psxy -R -J -Ss0.15 -W4 -G255/140/0 -O -K >>$psname.ps
      #echo 124.6 37.3 | psxy -R -J -Ss0.15 -W4 -G255/0/0 -O -K >>$psname.ps

      #echo 107 42.5 | psxy -R -J -Ss0.11 -W4 -G50/205/50 -O -K >>$psname.ps
      #echo "110 42.5 11 0 28 6 IORS" | pstext -R -J -O -K >>$psname.ps
      #echo 107 40 | psxy -R -J -Ss0.11 -W4 -G255/140/0 -O -K >>$psname.ps
      #echo "110 40 11 0 28 6 GORS" | pstext -R -J -O -K >>$psname.ps
      #echo 107 37.5 | psxy -R -J -Ss0.11 -W4 -G255/0/0 -O -K >>$psname.ps
      #echo "110 37.5 11 0 28 6 SORS" | pstext -R -J -O -K >>$psname.ps

# ================== plot legend ================

      echo 97 35 34  >temp2
      echo 102 35 64  >>temp2
      echo 107 35 83  >>temp2
      echo 112 35 96  >>temp2
      echo 117 35 114  >>temp2
      echo 122 35 136  >>temp2

      psxy temp2 -R -J -C13_scale_TC.cpt -Sc0.2 -Y0.2 -N -O -K  >>$psname.ps
      psxy temp2 -R -J -W8/0/0/0 -Sc0.2 -N -O -K  >>$psname.ps

      echo 97 36 14 0 0 2 TD/TS  >temp2
      echo 102 36 14 0 0 2 Cat.1  >>temp2
      echo 107 36 14 0 0 2 Cat.2  >>temp2
      echo 112 36 14 0 0 2 Cat.3  >>temp2
      echo 117 36 14 0 0 2 Cat.4  >>temp2
      echo 122 36 14 0 0 2 Cat.5  >>temp2
      pstext temp2 -R -J -G0/0/0  -N -O  >>$psname.ps

# ===============================================

      ps2raster $psname.ps -E300 -A -P -Tg

      rm temp2
      rm *.grd *.ps .gmt*

      echo ' ' 
      echo 'Figure successfully generated !!'
      echo ' ' 
      echo '======================================================================='

      exit 1

    elif [ $option = n ]; then

      results=$SST_plot'.*'
      mv $results result/
      mv *.txt result
      echo ' ' 
      echo 'Procedure stopped ...'
      echo ' ' 
      echo '======================================================================='
      exit 2

    fi

  else

    echo ' ' 
    echo 'Try again, please input [y/n]'
    echo ' ' 
    echo '======================================================================='

    echo 'SST data    : '$filename'.txt' 
    echo 'figure type : '$filename2 
    echo 'output name : '$psname'.png' 
    echo 'TC type     : '$TC_type 
    echo 'TC number   : '$TC_No
    echo 'TC name     : '$TC_name 
    echo 'TC warn     : '$Warning 

    if [ $SST_plot != $filename ]; then

      echo ' ' 
      echo "Warning : SST_INPUT_FILE and INPUT_FOR_PLOT are not consostent in namelist.input ."
      echo ' ' 

    fi

  fi

done
