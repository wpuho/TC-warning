#! /bin/sh

echo ' '
echo '======================================================================='
while read -p 'TC warning file is '"$input"', do you want to continue ? [y/n] ' option
do

  if [ $option = y ] || [ $option = n ]; then

    if [ $option = y ]; then

# ================== For fcst* ==================
 
      n1=`grep -n T000 $input | awk 'BEGIN{FS=":"} {print $1}'`
      n2=`grep -n AMP $input | awk 'BEGIN{FS=":"} {print $1}'`

      year_f=`awk 'BEGIN{FS=" "} NR=='$n1-1'{print substr($1,1,4)}' $input`
      month_f=`awk 'BEGIN{FS=" "} NR=='$n1-1'{print substr($1,5,2)}' $input`
      day_f=`awk 'BEGIN{FS=" "} NR=='$n1-1'{print substr($1,7,2)}' $input`
      hour_f=`awk 'BEGIN{FS=" "} NR=='$n1-1'{print substr($1,9,2)}' $input`

      warning_date_f=$year_f'-'$month_f'-'$day_f' '$hour_f':00:00'

# ================== For prvs* ==================

      k1=`grep -n // $input | awk 'BEGIN{FS=":"} {print $1}'`
      k1=`expr $k1 + 1`
      k2=`grep -n NNNN $input | awk 'BEGIN{FS=":"} {print $1}'`
      k2=`expr $k2 - 1`

# ================ Create fcst ==================

      rm $output'_fcst.txt'

      touch $output'_fcst.txt'

# --- For real time
      pos=`awk 'BEGIN{FS=" "} NR=='$k2'{print substr($2,1)}' $input`
      lat=${pos%N*}
      lat=`echo $lat*0.1 | bc`
      lon=${pos#*N}
      lon=${lon%E*}
      lon=`echo $lon*0.1 | bc`
      intensity=`awk 'BEGIN{FS=" "} NR=='$k2'{printf ("%d",substr($3,1))}' $input`
      year=`awk 'BEGIN{FS=" "} NR=='$k2'{print substr($1,3,2)}' $input`
      month=`awk 'BEGIN{FS=" "} NR=='$k2'{print substr($1,5,2)}' $input`
      day=`awk 'BEGIN{FS=" "} NR=='$k2'{print substr($1,7,2)}' $input`
      hour=`awk 'BEGIN{FS=" "} NR=='$k2'{print substr($1,9,2)}' $input`

      echo $lon' '$lat'  '$intensity'  20'$year$month$day$hour >>$output'_fcst.txt'
# ---

      fcst_num=(`grep -n 'VALID AT' $input | awk 'BEGIN{FS=":"} {print $1}'`)
      len=${#fcst_num[@]}

      fcst_n1=0
      fcst_n2=$len
      
      for ((nn=$fcst_n1; nn<$fcst_n2; nn++)) 
      do

	i=${fcst_num[$nn]}
	i_1=`expr $i + 1`
	i_2=`expr $i + 2`

        lat=`awk 'BEGIN{FS=" "} NR=='$i_1'{printf ("%5.1f",substr($3,0,4))}' $input`
	lon=`awk 'BEGIN{FS=" "} NR=='$i_1'{printf ("%5.1f",substr($4,0,5))}' $input`
        intensity=`awk 'BEGIN{FS=" "} NR=='$i_2'{print substr($5,0,3)}' $input`

	forcast_hour=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,0,3)}' $input`

        date=`date -d "$warning_date_f" +%s`
        date=`expr $date +  3600 \* $forcast_hour `
        date=`date "+%Y%m%d%H" --date=@$date`

        echo $lon'   ' $lat'   '$intensity'   '$date >>$output'_fcst.txt'

      done

# ============== Create fcst_label ==============

      rm $output'_fcst_label.txt'

      touch $output'_fcst_label.txt'

      for ((nn=$fcst_n1; nn<$fcst_n2; nn++)) 
      do

	i=${fcst_num[$nn]}
	i_1=`expr $i + 1`
	i_2=`expr $i + 2`
        
        lat=`awk 'BEGIN{FS=" "} NR=='$i_1'{printf ("%5.1f",substr($3,0,4))}' $input`
	lon=`awk 'BEGIN{FS=" "} NR=='$i_1'{printf ("%5.1f",substr($4,0,5))}' $input`
        intensity=`awk 'BEGIN{FS=" "} NR=='$i_2'{print substr($5,0,3)}' $input`

	forcast_hour=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,0,3)}' $input`
        
        date=`date -d "$warning_date_f" +%s`
        date=`expr $date +  3600 \* $forcast_hour `
        date=`date "+%Y%m%d%H" --date=@$date`

        year_f2=`echo $date | awk '{print substr($0,1,4)}'`
        month_f2=`echo $date | awk '{print substr($0,5,2)}'`
        day_f2=`echo $date | awk '{print substr($0,7,2)}'`
        hour_f2=`echo $date | awk '{print substr($0,9,2)}'`

	if [ $lb_fcst = 'LEFT' ]; then

          echo $lon'   '$lat'   ''12''   ''30''   ''0''   ''7''   '$month_f2'/'$day_f2$hour_f2'(F)'' //'$intensity' Knot--------' >>$output'_fcst_label.txt'

	else

          echo $lon'   '$lat'   ''12''   ''30''   ''0''   ''5''   ''--------'$month_f2'/'$day_f2$hour_f2'(F)'' //'$intensity' Knot' >>$output'_fcst_label.txt'
      
	fi

      done

# ================= Create prvs =================

      rm $output'_prvs.txt'

      touch $output'_prvs.txt'

      for ((i=$k1; i<=$k2; i++))
      do

        #lat=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%5.1f",substr($2,1,3)*0.1)}' $input`
        pos=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($2,1)}' $input`
	lat=${pos%N*}
	lat=`echo $lat*0.1 | bc`
        #lon=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%5.1f",substr($2,5,4)*0.1)}' $input`
	lon=${pos#*N}
	lon=${lon%E*}
	lon=`echo $lon*0.1 | bc`
        intensity=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%d",substr($3,1))}' $input`

        year=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,3,2)}' $input`
        month=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,5,2)}' $input`
        day=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,7,2)}' $input`
        hour=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,9,2)}' $input`

        echo $lon' '$lat'  '$intensity'  20'$year$month$day$hour >>$output'_prvs.txt'

      done

# ============== Create prvs_label ==============

      rm $output'_prvs_label.txt'

      touch $output'_prvs_label.txt'

      for ((i=$k1; i<=$k2; i++))
      do
	
        #lat=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%5.1f",substr($2,1,3)*0.1)}' $input`
        pos=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($2,1)}' $input`
	lat=${pos%N*}
	lat=`echo $lat*0.1 | bc`
        #lon=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%5.1f",substr($2,5,4)*0.1)}' $input`
	lon=${pos#*N}
	lon=${lon%E*}
	lon=`echo $lon*0.1 | bc`
        intensity=`awk 'BEGIN{FS=" "} NR=='$i'{printf ("%d",substr($3,1))}' $input`

        year=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,3,2)}' $input`
        month=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,5,2)}' $input`
        day=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,7,2)}' $input`
        hour=`awk 'BEGIN{FS=" "} NR=='$i'{print substr($1,9,2)}' $input`

        if [ $hour = '00' ]; then

	  if [ $lb_prvs = 'LEFT' ]; then

	    echo $lon'   '$lat'   ''12''   ''30''   ''0''   ''7''   '$month'/'$day' // '$intensity' Knot --------' >>$output'_prvs_label.txt'
	  
	  else
            
            echo $lon'   '$lat'   ''12''   ''30''   ''0''   ''5''   ''--------'$month'/'$day' // '$intensity' Knot' >>$output'_prvs_label.txt'
          fi

	fi

      done

# ===============================================

      mv $input result/
      echo ' ' 
      echo 'TC track data successfully generated !!'
      echo ' ' 
      echo '======================================================================='
      exit 1

    elif [ $option = n ]; then
 
      results=$SST_plot'.*'
      mv $results result/
      rm $input
      echo ' ' 
      echo 'Procedure stop ...'
      echo ' ' 
      echo '======================================================================='
      exit 2

    fi

  else
  
  #results=$filename'.*'
  #mv $results result/
  #rm $input
  echo ' ' 
  echo 'Try again, please input [y/n]'
  echo ' ' 
  echo '======================================================================='
  #exit 3

  fi

done
