#! /bin/sh

filename=20200824
filename2=wtf_wp0920 # forcast date
psname=20200824_wtf
TC_type=Typhoon
TC_No=09W
TC_name=BAVI
Warning=11

##### COLOR BAR #####
cptL=26		    #
cptR=32		    #
cint=0.1 	    #
		    #
cinta=0.5	    #
cintf=1 	    #
#####################

gmtset ANOT_FONT_SIZE 16
gmtset HEADER_FONT_SIZE 24
gmtset PLOT_DEGREE_FORMAT ddd:mm:ssF MEASURE_UNIT inch PAPER_MEDIA a0

#makecpt -Csst -T25/32/0.5 -D > SST2.cpt

surface $filename'.txt' -Gdata.grd -I0.25 -R99.125/300.125/0.125/51.125 -S1 -T0 -Z1.7

grdsample data.grd -I0.1 -R -Gdata.grd

grdimage data.grd -R105/165/10/45 -JQ180/9 -CSST.cpt -Y3.9 -X1 -K       >$psname.ps
psxy $filename'.mask' -R -G100 -J -Ss0.06 -K  -O                 >>$psname.ps

pscoast -J -R -G200 -W1 -Ba10f5/a5f5WeSn -Di -O -K  >>$psname.ps

echo 162 46.4 17 0 28 6 $filename >> temp2
pstext temp2 -R -J -G255 -S10/0/0/0 -N -K -O >>$psname.ps

echo 151.5 48 15 0 28 6 'Tropical '$TC_type' '$TC_No' ('$TC_name') Warning #'$Warning >> temp2
pstext temp2 -R -J -G255 -S10/0/0/0 -N -K -O >>$psname.ps

#echo 139.7 .3 15 0 28 6 >> temp2

# -------------add track----------------

psxy $filename2 -R -J -O  -W7/0/0/0  -K    >> $psname.ps
psxy $filename2 -R -J -O  -Ctc_scale1.cpt -Sc0.12 -K    >> $psname.ps
psxy $filename2 -R -J -O  -W4/0/0/0 -Sc0.13 -K    >> $psname.ps

psxy $filename2'f' -R -J -O  -W7,0/0/0,-   -K    >> $psname.ps
psxy $filename2'f' -R -J -O  -Ctc_scale1.cpt -Sc0.12 -K    >> $psname.ps
psxy $filename2'f' -R -J -O  -W4,0/0/0,- -Sc0.13 -K    >> $psname.ps

pstext $filename2'in' -R -J -G0/0/0 -S8/255/255/255   -K  -O   >>$psname.ps

pstext $filename2'inf' -R -J -G0/0/0  -S8/255/255/5   -K  -O   >>$psname.ps

gmtset ANOT_FONT_SIZE 16
gmtset LABEL_FONT_SIZE 16
#psscale -CSST.cpt -D4.5/-0.5/9/0.1h -L -B::/:"@+o@+C": -K  -O -E   >>$psname.ps
psscale -CSST.cpt -D4.5/-0.5/9/0.1h -Ba$cintaf$cintf::/:"@+o@+C": -E -K -O >>$psname.ps


echo 169.5 0.5 20 0 9 3 >temp2
pstext temp2 -R110/170/0/30 -J -N -O -K >>$psname.ps

# ----------- plot legend ---------------

echo 112 35 34 > temp2
echo 117 35 64 >> temp2
echo 122 35 83 >> temp2
echo 127 35 96 >> temp2
echo 132 35 114 >> temp2
echo 137 35 136 >> temp2

psxy temp2 -R -J -Ctc_scale1.cpt -Sc0.2 -Y0.2 -N -K -O >> $psname.ps
psxy temp2 -R -J -W8/0/0/0 -Sc0.2 -N -K -O >> $psname.ps

echo 112 36 14 0 0 2 TD/TS> temp2
echo 117 36 14 0 0 2 Cat.1>> temp2
echo 122 36 14 0 0 2 Cat.2>> temp2
echo 127 36 14 0 0 2 Cat.3>> temp2
echo 132 36 14 0 0 2 Cat.4>> temp2
echo 137 36 14 0 0 2 Cat.5>> temp2
pstext temp2 -R -J -G0/0/0 -K  -O  -N >>$psname.ps



echo 169 33 26 0 0 7 >temp2
pstext temp2 -R -J -N -O >>$psname.ps

ps2raster $psname.ps -E300 -A -P -Tg

rm temp2
rm *.grd *.ps
