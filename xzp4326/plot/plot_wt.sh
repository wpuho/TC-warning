#! /bin/sh

#for ((j=1; j<=1; j++))
#do

filename=20200828
track_file=wt_20200828
psname=20200828_wt

TC_type=Depression
TC_No=10W
TC_name=TEN
Warning=01



#####################

title=Temperature
unit=degc

##### COLOR BAR #####
cptL=26		    #
cptR=32		    #
cint=0.1 	    #
		    #
cinta=0.5	    #
cintf=1 	    #
#####################

for ((i=1; i<=1; i++))
do

if [ $i -le 21 ]; then
 
ii=`expr $i - 1`
ii=`expr $ii \* 5`

else

i1=100
ii=`expr $i - 21`
ii=`expr 25 \* $ii`
ii=`expr $i1 + $ii`

fi

# -------------------------------------

gmtset ANOT_FONT_SIZE 16
gmtset HEADER_FONT_SIZE 24
gmtset PLOT_DEGREE_FORMAT ddd:mm:ssF MEASURE_UNIT inch PAPER_MEDIA a0

#makecpt -Cjet -T$cptL/$cptR/$cint -D > colorbar.cpt

surface $filename.txt -Gdata.grd -I0.1 -R105/165/10/45 -S1 -T0 -Z1.7

grdsample data.grd -I0.1 -R -Gdata.grd

grdimage data.grd -R105/165/10/45 -JQ180/9 -CSST.cpt -Y3.9 -X1 -K >$psname.ps

psxy $filename.mask -R -G100 -J -Ss0.06 -K  -O >>$psname.ps

pscoast -G200 -J -R  -W1 -Ba10f5/a5f5WeSn -Di -O -K >>$psname.ps

echo 162 46.4 17 0 28 6 $filename >> temp2
pstext temp2 -R -J -G255 -S10/0/0/0 -N -K -O >>$psname.ps

echo 151.5 48 15 0 28 6 'Tropical '$TC_type' '$TC_No' ('$TC_name') Warning #'$Warning >> temp2
pstext temp2 -R -J -G255 -S10/0/0/0 -N -K -O >>$psname.ps


#echo 129.7 .3 15 0 28 6 >> temp2


#grdcontour f12_f32_%1.grd -Clabel_pos.dat -A+k0+s10 -W1/0/0/0 -R -Gd3.5i -J -O -K   >>OISST.ps

#pscoast -J -R -G200 -W1 -Ba10f5/a5f5WeSn:.Depth" "=" "$ii" "m: -Di -O -K  >>$psname"_"$i.ps
#pscoast -J -R -G200 -W1 -Ba10f5/a5f5WeSn -Di -O -K  >>$psname"_"$i.ps

#psscale -COISST.cpt -D4.5/-0.5/9/0.1h -L -B::/:"@+o@+C": -K  -O -E   >>OISST.ps
#psscale -COISST.cpt -D4.5/-0.5/4.5/0.2h -Ba1f0.5:"@+o@+C": -K  -O  >>OISST.ps
#psscale -CSST.cpt -D4.5/-0.5/10/0.2h -Ba$cintaf$cintf:$title:/:$unit: -K  -O  >>$psname.ps

#psscale -CSST.cpt -D4.5/-0.5/9/0.1h -Ba$cintaf$cintf::/:$unit: -E  -O  >>$psname.ps

#psscale -CSST.cpt -D4.5/-0.5/9/0.1h -L -B::/:"@+o@+C":  -O -E >>$psname.ps

# -------------add track----------------

#psxy $track_file -R -J -W7/0/0/0 -K -O   >> $psname.ps
psxy $track_file -R -J -Ctc_scale1.cpt -Sc0.12 -K -O >> $psname.ps
psxy $track_file -R -J -W4/0/0/0 -Sc0.13 -K -O >> $psname.ps

pstext $track_file'in' -R -J -G0/0/0 -S8/255/255/255 -K -O >>$psname.ps

# --------------------------------------

gmtset ANOT_FONT_SIZE 16
gmtset LABEL_FONT_SIZE 16

psscale -CSST.cpt -D4.5/-0.5/9/0.1h -Ba$cintaf$cintf::/:"@+o@+C": -E -K -O >>$psname.ps

echo 169.5 0.5 20 0 9 3 >temp2
pstext temp2 -R110/170/0/30 -J -N -O -K >>$psname.ps

echo 112 35 34 > temp2
echo 117 35 64 >> temp2
echo 122 35 83 >> temp2
echo 127 35 96 >> temp2
echo 132 35 114 >> temp2
echo 137 35 136 >> temp2

psxy temp2 -R -J -Ctc_scale1.cpt -Sc0.2 -Y0.2 -N -K -O >> $psname.ps
psxy temp2 -R -J -W8/0/0/0 -Sc0.2 -N -K -O  >> $psname.ps

echo 112 36 14 0 0 2 TD/TS> temp2
echo 117 36 14 0 0 2 Cat.1>> temp2
echo 122 36 14 0 0 2 Cat.2>> temp2
echo 127 36 14 0 0 2 Cat.3>> temp2
echo 132 36 14 0 0 2 Cat.4>> temp2
echo 137 36 14 0 0 2 Cat.5>> temp2
pstext temp2 -R -J -G0/0/0 -N -K -O >>$psname.ps

echo 169 33 26 0 0 7 >temp2
pstext temp2 -R -J -N -O >>$psname.ps

# -------------------------------------

ps2raster $psname.ps -E300 -A -P -Tg

rm temp2
rm *.grd *.ps

done

#done
