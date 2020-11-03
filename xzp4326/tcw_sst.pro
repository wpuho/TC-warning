pro tcw_sst

X = bin_date(systime())
Y = STRING(X[0],format = '(i04)')+STRING(X[1],format = '(i02)')+STRING(X[2],format = '(i02)')
opath = '/home/wpuho/TC_warning/xzp4326/'
tcw_sstt,'247',Y,X,opath





end

PRO tcw_sstt,bbmp,Y,X,opath

  opath = opath
  a = DIALOG_PICKFILE(path=opath,/READ, FILTER = '*.tcwi',/multiple_files,GET_PATH=PATH1)
  b = DIALOG_PICKFILE(path=opath,/READ, FILTER = '*.tcwf',/multiple_files,GET_PATH=PATH)
  if b eq '' then begin;no forcase
    nl =  file_lines(a)
    nl = nl(0)
    ny = dblarr(5,nl)
    openr,1,a
    readf,1,ny
    close,1
    mmd = strmid(string(ny(3,*),format = '(I10)'),6,2)
    mmd=mmd[uniq(mmd)]
    dayh = string(ny(3,*),format = '(I10)')
    for i  = 0,n_elements(mmd)-1 do begin
      dayz = where(strmid(string(ny(3,*),format = '(I10)'),6,2) eq mmd(i))
      year = strmid(string(dayh(dayz(0)),format = '(I10)'),0,4)
      month = strmid(string(dayh(dayz(0)),format = '(I10)'),4,2)
      day = strmid(string(dayh(dayz(0)),format = '(I10)'),6,2)
      days = julday(month,day,year)-julday(1,0,year)
      dayks = string(days,format='(i03)')
      
      if dayks lt bbmp then begin
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.v05.0.gz'
        read_oi_sst, d, sst
        
        sst[where(sst gt 250)] = !VALUES.F_NAN
        openw,3,path1+year+month+day+'.txt'
        openw,4,path1+year+month+day+'.mask'
        for j = 0,720-1 do begin
          lat=-89.875+j*0.25
          for k = 0,1440-1 do begin
            lon=0.125+k*0.25
            if finite(sst[k,j]) then begin
              printf,3,lon,lat,sst[k,j],format='(3f10.3)'
            endif else begin
              printf,4,lon,lat
            endelse
            ;           if finite(cooling[k,j]) then begin
            ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
            ;           endif else begin
            ;            printf,6,lon,lat
            ;           endelse
          endfor
        endfor
        close,3,4
        openw,1,path1+'wt_'+year+month+day
        openw,2,path1+'wt_'+year+month+day+'in'
        for j = 0,max(dayz) do begin
          dd = dayh(j)
          year = strmid(string(dd,format = '(I10)'),0,4)
          month = strmid(string(dd,format = '(I10)'),4,2)
          day = strmid(string(dd,format = '(I10)'),6,2)
          mm = strmid(string(dd,format = '(I10)'),8,2)
          lon = strmid(string(ny(0,j),format = '(f5.1)'),0,5)
          lat = strmid(string(ny(1,j),format = '(f5.1)'),0,5)
          int = strmid(string(ny(2,j),format = '(f5.1)'),0,5)
          printf,1,lon,lat,int,year+month+day+mm,format = '(3f10.1,2x,a)'
          if mm eq '00' then begin
            dayss = '--------'+month+'/'+day+' //'+int+' Knot'
            printf,2,lon,lat,12,90,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
          endif
        endfor
        close,1,2
      endif else begin
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.rt.gz'
        
        read_oi_sst, d, sst
        
        sst[where(sst gt 250)] = !VALUES.F_NAN
        openw,3,path1+year+month+day+'.txt'
        openw,4,path1+year+month+day+'.mask'
        for j = 0,720-1 do begin
          lat=-89.875+j*0.25
          for k = 0,1440-1 do begin
            lon=0.125+k*0.25
            if finite(sst[k,j]) then begin
              printf,3,lon,lat,sst[k,j],format='(3f10.3)'
            endif else begin
              printf,4,lon,lat
            endelse
            ;           if finite(cooling[k,j]) then begin
            ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
            ;           endif else begin
            ;            printf,6,lon,lat
            ;           endelse
          endfor
        endfor
        close,3,4
        openw,1,path1+'wt_'+year+month+day
        openw,2,path1+'wt_'+year+month+day+'in'
        for j = 0,max(dayz) do begin
          dd = dayh(j)
          year = strmid(string(dd,format = '(I10)'),0,4)
          month = strmid(string(dd,format = '(I10)'),4,2)
          day = strmid(string(dd,format = '(I10)'),6,2)
          mm = strmid(string(dd,format = '(I10)'),8,2)
          lon = strmid(string(ny(0,j),format = '(f5.1)'),0,5)
          lat = strmid(string(ny(1,j),format = '(f5.1)'),0,5)
          int = strmid(string(ny(2,j),format = '(f5.1)'),0,5)
          printf,1,lon,lat,int,year+month+day+mm,format = '(3f10.1,2x,a)'
          if mm eq '00' then begin
            dayss = '--------'+month+'/'+day+' //'+int+' Knot'
            printf,2,lon,lat,12,90,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
          endif
        endfor
        close,1,2
      endelse
    endfor
  endif else begin
    nl = file_lines(b)
    nl = nl(0)
    nc = dblarr(4,nl)
    openr,1,b
    readf,1,nc
    close,1

    nl =  file_lines(a)
    nl = nl(0)
    ny = dblarr(5,nl)
    openr,1,a
    readf,1,ny
    close,1

    ;nc = [nc(0:1,*),int,nc(2,*),int]

    openw,1,path+'wtf_'+strmid(file_basename(a),0,6)
    openw,3,path+'wtf_'+strmid(file_basename(a),0,6)+'f'
    openw,2,path+'wtf_'+strmid(file_basename(a),0,6)+'in'
    m1 = strmid(string(ny(3,*),format = '(I10)'),8,2)
    for i = 0,n_elements(m1)-1 do begin
      if m1[i] eq '00' then begin
        dayss = '--------'+strmid(string(ny[3,i],format = '(I10)'),4,2)+'/'+strmid(string(ny[3,i],format = '(I10)'),6,2)+' //'+string(ny[2,i],format = '(i3)')+' Knot'
        printf,2,ny[0:1,i],12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
      endif
    endfor  
    openw,4,path+'wtf_'+strmid(file_basename(a),0,6)+'inf'
    mm = strmid(string(nc(3,*),format = '(I10)'),8,2)
    for j = 0,n_elements(mm)-1 do begin
      dayss = '--------'+strmid(string(nc[3,j],format = '(I10)'),4,2)+'/'+strmid(string(nc[3,j],format = '(I10)'),6,4)+'(F)'+' //'+string(nc[2,j],format = '(i3)')+' Knot'
      printf,4,nc[0:1,j],12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
    endfor
    printf,1,ny(0:3,*),format = '(2f10.1,2x,1i3,2x,1i10)'
    printf,3,ny(0:3,nl-1),format = '(2f10.1,2x,1i3,2x,1i10)'
    printf,3,nc(*,*),format = '(2f10.1,2x,1i3,2x,1i10)'
    
    
    
    close,1,2,3,4
    
    mmd = strmid(string(ny(3,*),format = '(I10)'),6,2)
    mmd=mmd[uniq(mmd)]
    dayh = string(ny(3,*),format = '(I10)')
    
    if long(y) GT strmid(max(dayh),0,8) then begin
      days = julday(X[1],X[2],X[0])-julday(1,0,X[0])
      year = STRING(X[0],format = '(i04)')
      month = STRING(X[1],format = '(i02)')
      day = STRING(X[2],format = '(i02)')
      dayks = STRING(days,format = '(i03)')
      if days lt bbmp then begin
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.v05.0.gz'
        read_oi_sst, d, sst

        sst[where(sst gt 250)] = !VALUES.F_NAN
        openw,3,path+year+month+day+'.txt'
        openw,4,path+year+month+day+'.mask'
        for j = 0,720-1 do begin
          lat=-89.875+j*0.25
          for k = 0,1440-1 do begin
            lon=0.125+k*0.25
            if finite(sst[k,j]) then begin
              printf,3,lon,lat,sst[k,j],format='(3f10.3)'
            endif else begin
              printf,4,lon,lat
            endelse
            ;           if finite(cooling[k,j]) then begin
            ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
            ;           endif else begin
            ;            printf,6,lon,lat
            ;           endelse
          endfor
        endfor
        close,3,4
      endif else begin
        
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.rt.gz'
        read_oi_sst, d, sst
        sst[where(sst gt 250)] = !VALUES.F_NAN
        openw,3,path+year+month+day+'.txt'
        openw,4,path+year+month+day+'.mask'
        for j = 0,720-1 do begin
          lat=-89.875+j*0.25
          for k = 0,1440-1 do begin
            lon=0.125+k*0.25
            if finite(sst[k,j]) then begin
              printf,3,lon,lat,sst[k,j],format='(3f10.3)'
            endif else begin
              printf,4,lon,lat
            endelse
            ;           if finite(cooling[k,j]) then begin
            ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
            ;           endif else begin
            ;            printf,6,lon,lat
            ;           endelse
          endfor
        endfor
      endelse 
      close,3,4      
    endif
   
      for i  = 0,n_elements(mmd)-1 do begin
        dayz = where(strmid(string(ny(3,*),format = '(I10)'),6,2) eq mmd(i))
        year = strmid(string(dayh(dayz(0)),format = '(I10)'),0,4)
        month = strmid(string(dayh(dayz(0)),format = '(I10)'),4,2)
        day = strmid(string(dayh(dayz(0)),format = '(I10)'),6,2)
        days = julday(month,day,year)-julday(1,0,year)
        dayks = string(days,format='(i03)')

        if dayks lt bbmp then begin
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.v05.0.gz'
          read_oi_sst, d, sst

          sst[where(sst gt 250)] = !VALUES.F_NAN
          openw,3,path+year+month+day+'.txt'
          openw,4,path+year+month+day+'.mask'
          for j = 0,720-1 do begin
            lat=-89.875+j*0.25
            for k = 0,1440-1 do begin
              lon=0.125+k*0.25
              if finite(sst[k,j]) then begin
                printf,3,lon,lat,sst[k,j],format='(3f10.3)'
              endif else begin
                printf,4,lon,lat
              endelse
              ;           if finite(cooling[k,j]) then begin
              ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
              ;           endif else begin
              ;            printf,6,lon,lat
              ;           endelse
            endfor
          endfor
          close,3,4
          openw,1,path+'wt_'+year+month+day
          openw,2,path+'wt_'+year+month+day+'in'
          for j = 0,max(dayz) do begin
            dd = dayh(j)
            year = strmid(string(dd,format = '(I10)'),0,4)
            month = strmid(string(dd,format = '(I10)'),4,2)
            day = strmid(string(dd,format = '(I10)'),6,2)
            mm = strmid(string(dd,format = '(I10)'),8,2)
            lon = strmid(string(ny(0,j),format = '(f5.1)'),0,5)
            lat = strmid(string(ny(1,j),format = '(f5.1)'),0,5)
            int = strmid(string(ny(2,j),format = '(f5.1)'),0,5)
            printf,1,lon,lat,int,year+month+day+mm,format = '(3f10.1,2x,a)'
            if mm eq '00' then begin
              dayss = '--------'+month+'/'+day+' //'+int+' Knot'
              printf,2,lon,lat,12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
            endif
          endfor
          close,1,2
        endif else begin
        d = '/home/wpuho/TC_warning/xzp4326/mw.fusion.'+year+'.'+dayks+'.rt.gz'
          read_oi_sst, d, sst
          sst[where(sst gt 250)] = !VALUES.F_NAN
          openw,3,path+year+month+day+'.txt'
          openw,4,path+year+month+day+'.mask'
          for j = 0,720-1 do begin
            lat=-89.875+j*0.25
            for k = 0,1440-1 do begin
              lon=0.125+k*0.25
              if finite(sst[k,j]) then begin
                printf,3,lon,lat,sst[k,j],format='(3f10.3)'
              endif else begin
                printf,4,lon,lat
              endelse
              ;           if finite(cooling[k,j]) then begin
              ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
              ;           endif else begin
              ;            printf,6,lon,lat
              ;           endelse
            endfor
          endfor
          close,3,4
          openw,1,path+'wt_'+year+month+day
          openw,2,path+'wt_'+year+month+day+'in'
          for j = 0,max(dayz) do begin
            dd = dayh(j)
            year = strmid(string(dd,format = '(I10)'),0,4)
            month = strmid(string(dd,format = '(I10)'),4,2)
            day = strmid(string(dd,format = '(I10)'),6,2)
            mm = strmid(string(dd,format = '(I10)'),8,2)
            lon = strmid(string(ny(0,j),format = '(f5.1)'),0,5)
            lat = strmid(string(ny(1,j),format = '(f5.1)'),0,5)
            int = strmid(string(ny(2,j),format = '(f5.1)'),0,5)
            printf,1,lon,lat,int,year+month+day+mm,format = '(3f10.1,2x,a)'
            if mm eq '00' then begin
              dayss = '--------'+month+'/'+day+' //'+int+' Knot'
              printf,2,lon,lat,12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
            endif
          endfor
          close,1,2
        endelse
      endfor
      
  
    
  endelse
  
  
  end
;  121.1   19.9  12  0   0   5  --------09/08
;  122.7   21.3  12  0   0   5  --------09/09
;  121.6   21.6  12  30   0   5  --------09/10
;  days = julday(month,day,year)-julday(1,0,year)
;  
;  days = julday(8,7,2018)-julday(1,0,2018)
;  dayks = string(days,format='(i03)')
;  e = 'F:\RSS\SST\daily\mw\v05.0\bmaps\2018\mw.fusion.2018.'+dayks+'.v05.0.gz'
;  read_oi_sst, e, sd
;  sd[where(sd ge 250)] = !VALUES.F_NAN
;  for i = 0,nl-1 do begin
;      dd = ny(3,i)
;      year = strmid(string(dd,format = '(I10)'),0,4)
;      month = strmid(string(dd,format = '(I10)'),4,2)
;      day = strmid(string(dd,format = '(I10)'),6,2)
;      mm = strmid(string(dd,format = '(I10)'),8,2)
;      lon = strmid(string(ny(0,i),format = '(f5.1)'),0,5) 
;      lat = strmid(string(ny(1,i),format = '(f5.1)'),0,5)  
;      int = strmid(string(ny(2,i),format = '(f5.1)'),0,5) 
;            
;      days = julday(month,day,year)-julday(1,0,year)
;      dayks = string(days,format='(i03)')
;     if dayks lt '239' then begin
;       d = 'F:\RSS\SST\daily\mw\v05.0\bmaps\'+year+'\mw.fusion.'+year+'.'+dayks+'.v05.0.gz'
;       read_oi_sst, d, sst
;       sst[where(sst gt 250)] = !VALUES.F_NAN
;       ;       cooling = sd-sst
;       openw,3,path+year+month+day
;       openw,4,path+year+month+day+'.mask'
;       ;       openw,5,opath+year+month+day+'co'
;       ;       openw,6,opath+year+month+day+'co.mask'
;
;       for j = 0,720-1 do begin
;         lat=-89.875+j*0.25
;         for k = 0,1440-1 do begin
;           lon=0.125+k*0.25
;           if finite(sst[k,j]) then begin
;             printf,3,lon,lat,sst[k,j],format='(3f10.3)'5
;           endif else begin
;             printf,4,lon,lat
;           endelse
;           ;           if finite(cooling[k,j]) then begin
;           ;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
;           ;           endif else begin
;           ;            printf,6,lon,lat
;           ;           endelse
;         endfor
;       endfor
;       close,3,4
;       openw,1,path+'wt_'+year+month+day
;       openw,2,path+'wt_'+year+month+day+'in'
;
;      endif else begin 
;      d = 'F:\RSS\SST\daily\mw\v05.0\bmaps\'+year+'\mw.fusion.'+year+'.'+dayks+'.rt.gz'   
;      read_oi_sst, d, sst
;      sst[where(sst gt 250)] = !VALUES.F_NAN
;;      cooling = sd-sst
;      openw,3,path+year+month+day
;      openw,4,path+year+month+day+'.mask'
;;      openw,5,opath+year+month+day+'co'
;;      openw,6,opath+year+month+day+'co.mask'
;
;      for j = 0,720-1 do begin
;        lat=-89.875+j*0.25
;        for k = 0,1440-1 do begin
;          lon=0.125+k*0.25
;          if finite(sst[k,j]) then begin
;            printf,3,lon,lat,sst[k,j],format='(3f10.3)'
;          endif else begin
;            printf,4,lon,lat
;          endelse
;;          if finite(cooling[k,j]) then begin
;;            printf,5,lon,lat,cooling[k,j],format='(3f10.3)'
;;          endif else begin
;;            printf,6,lon,lat
;;          endelse
;        endfor
;      endfor
;      close,3,4
;      openw,1,path+'wt_'+year+month+day
;      openw,2,path+'wt_'+year+month+day+'in'
;      for k = 0,i do  begin
;        month1 = strmid(string(ny(3,k),format = '(I10)'),4,2)
;        day1 = strmid(string(ny(3,k),format = '(I10)'),6,2)
;        mm = strmid(string(ny(3,k),format = '(I10)'),8,2)
;        dayss = '--------'+month1+'/'+day1
;        printf,1,strmid(string(ny(0,k),format = '(f5.1)'),0,5),strmid(string(ny(1,k),format = '(f5.1)'),0,5),strmid(string(ny(2,k),format = '(f5.1)'),0,5),string(ny(3,k),format = '(I10)'),format = '(3f7.1,2x,a)'
;        if mm eq '00' then begin
;        dayss = '--------'+month1+'/'+day1
;        printf,2,strmid(string(ny(0,k),format = '(f5.1)'),0,5),strmid(string(ny(1,k),format = '(f5.1)'),0,5),12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'  
;        endif        
;      endfor
;      if day1 eq dayz and i lt nl then begin
;        while(i ne nl-1) do begin
;          i++
;          printf,2,strmid(string(ny(0,i),format = '(f5.1)'),0,5),strmid(string(ny(1,i),format = '(f5.1)'),0,5),12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'
;
;        endwhile
;      endif
;      close,1,2
;      endelse  
;   endfor
  
PRO read_oi_sst, file_name, sst

  ; this routine will read the OI-SST (TMI and AMSR-E) daily bytemap files.
  ;
  ; The routine returns:
  ;   sst, real arrays sized (1440,720)
  ;   sst   is the sea surface temperature in degree Celcius, valid range=[-3.0,34.5]
  ;
  ; Longitude  is 0.25*(xdim+1)-0.125     !IDL is zero based    East longitude
  ; Latitude   is 0.25*(ydim+1)-90.125
  ;
  ; This rountine is coded based on the program of AMSR-E daily map from RSS.
  ; Pun, I-F (2005-11-8)



  ;binary data in file
  binarydata= bytarr(1440,720)

  ;output product (lon,lat)
  sst  =fltarr(1440,720)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;determine if file exists
  exist=findfile(file_name,COUNT=cnt)
  if (cnt ne 1) then begin
    print, 'FILE DOES NOT EXIST  or MORE THAN ONE FILE EXISTS!!'
  endif else begin

    ;open file, read binary data, close file
    close,2
    openr,2,file_name, error=err, /compress   ;compress keyword allows reading of gzip file, remove if data already unzipped
    if (err gt 0) then begin
      print, 'ERROR OPENING FILE: ', file_name
    endif else begin
      readu,2,binarydata
      close,2
    endelse

    ; SST
    ok=where(binarydata le 250)
    binarydata=float(binarydata)
    binarydata[ok]=binarydata[ok]*0.15-3.0
    sst[*,*] =binarydata

  endelse


  return
END

 
