pro tcw

;wp1518.tcw
;opath = 'D:\Warning track\wp0720\'
opath = '/home/wpuho/TC_warning/'
a = DIALOG_PICKFILE(path=opath+'TCW',/READ, FILTER = '*.tcw',/multiple_files,GET_PATH=PATH)
fl = file_lines(a)
at = strarr(1,fl)
openr,1,a
readf,1,at
close,1
;Warning track

FP = file_basename(a)

tmp = strpos(at,'REMARKS:',/reverse_search) 
tmp1 = strpos(at[where(tmp ge 0):fl-1],strmid(FP,2,4),/reverse_search) 
tmp1 = where(tmp1 GE 0)
tmp1 = where(tmp ge 0)+tmp1[0]
tmp1 = tmp1[0]

tmp2 = strpos(at,'NNNN',/reverse_search)  
tmp2 = where(tmp2 eq 0)
tmp2 = tmp2[0]-1
;
;Forecasts

tmp3 = strpos(at,'VALID AT',/reverse_search)
tmp3 = where(tmp3 ne -1)
tmp4 = strpos(at,'REMARKS:',/reverse_search)
tmp4 = where(tmp4 ne -1)
tmp4 = tmp4[0]
tmp5 = strpos(at,'MAX SUSTAINED WINDS',/reverse_search)
tmp5 = where(tmp5 ne -1)

;1518071912
openw,2,opath+file_basename(a)+'i'
;openw,2,path+file_basename(a)+'.in'
for i = tmp1,tmp2 do begin
 
  
  lat = strpos(at[i],'N',/reverse_search) 
  ;lon = strpos(at[i],'E',/reverse_search)
  lon = strmid(at[i],lat+1,4)/10.0
  lat = strmid(at[i],lat-4,4)/10.0 
  no = strmid(at[i],0,2)
  year = strmid(at[i],2,2)
  month = strmid(at[i],4,2)
  day = strmid(at[i],6,2)
  mm = strmid(at[i],8,2)
  find = strpos(at[i],'N',/reverse_search)
  int = strmid(at[i],find+7,3)
  int = fix(int)
  days = julday(month,day,year)-julday(1,0,year)
  printf,2,lon,lat,int,'20'+year+month+day+mm,no,format = '(3f7.1,2x,a,2x,a)'

  
  ;if mm eq '00' then begin
    ;dayss = '--------'+month+'/'+day
    ;printF,2,lon,lat,12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'

  ;endif
endfor
close,2
;print,at[tmp2]
;stop
month = fix(strmid(at[tmp2],4,2))
year = fix(strmid(at[tmp2],2,2))

tmp41 = where(strmid(at[tmp3+1],3,2) eq '01',cc)
if tmp3[0] ne -1 then begin
  openw,1,opath+file_basename(a)+'f'
  ;tmp3+4,tmp4-16,18
  for j = 0,n_elements(tmp3)-1 do begin
    
    lon = strpos(at[tmp3[j]+1],'E',/reverse_search)
    lon = strmid(at[tmp3[j]+1],lon-5,5)
    lat = strpos(at[tmp3[j]+1],'N',/reverse_search)
    lat = strmid(at[tmp3[j]+1],lat-4,4)
    day = strmid(at[tmp3[j]+1],3,2)
    mm = strmid(at[tmp3[j]+1],5,2)
    int = string(strmid(at[tmp3[j]+2],25,3),format = '(i3)')
   
    if cc gt 0 and strmid(at[tmp3[j]+1],3,4) eq strmid(at[tmp3[tmp41[0]]+1],3,4) and strmid(at[tmp3[0]+1],3,4) ne strmid(at[tmp3[tmp41[0]]+1],3,4) then month = month+1
    if month gt 13 then  year = year+1
    year  = string(year,format = '(i02)')
    month = string(month,format = '(i02)')

    ;  r34_1 = strmid(at[tmp5[j]],28,3)
    ;  r34_2 = strmid(at[tmp5[j]+3],28,3)
    ;  r34_3 = strmid(at[tmp5[j]+2],28,3)
    ;  r34_4 = strmid(at[tmp5[j]+1],28,3)
    printf,1,lon,lat,int,'20'+year+month+day+mm,format = '(2f7.1,2x,a,2x,a)'


    
  endfor
  close,1
endif

  

  ;printf,1,lon,lat,int,'20'+year+month+day+mm,no,format = '(3f7.1,2x,a,2x,a)'


  ;if mm eq '00' then begin
  ;dayss = '--------'+month+'/'+day
  ;printF,2,lon,lat,12,30,0,5,dayss,format = '(2f7.1,4i4,2x,a)'

  ;endif

end

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

pro read_rss_mwr_day, filename, time, sst, wind_lf, wind_mf, vapor, cloud, rain

  ; reads the RSS daily bytemap files for:
  ;
  ;      GMI, TMI, AMSR-2, AMSR-E
  ;
  ; parameter 1 = filename (including path): f**_yyyymmddv*.gz, where
  ;      f**   = file descriptor
  ;      yyyy  = year
  ;      mm    = month
  ;      dd    = day
  ;      v*    = version
  ;
  ; parameters 2-7 = real number arrays sized (1440,720,2):
  ;   time    = UTC time of observation in fractional hours,  valid range=[ 0.0,  24.0 ]
  ;   sst     = sea surface temperature in degrees C,         valid range=[-3.0,  34.5 ]
  ;   wind_lf = 10 meter surface wind speed in meters/second, valid range=[ 0.,   50.0 ]  predominantly 11 GHz (lf = low frequency)
  ;   wind_mf = 10 meter surface wind speed in meters/second, valid range=[ 0.,   50.0 ]  predominantly 37 GHz (mf = medium frequency)
  ;   vapor   = atmospheric water vapor in millimeters,       valid range=[ 0.,   75.0 ]
  ;   cloud   = cloud liquid water in millimeters,            valid range=[-0.05,  2.45]
  ;   rain    = instantaneous rain rate in millimeters/hour,  valid range=[ 0.,   25.0 ]
  ;
  ;
  ; Geolocation is stored within the grid index:
  ; Longitude  is 0.25 * ( index_longitude + 1) -  0.125     !IDL is zero based    East longitude
  ; Latitude   is 0.25 * ( index_latitude  + 1) - 90.125
  ;
  ;
  ; www.remss.com
  ; www.remss.com/support



  ;allocate byte data to read from file
  byte_data = bytarr(1440,720,7,2)

  ;output products[lon,lat,asc/dsc]
  time    = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  sst     = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  wind_lf = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  wind_mf = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  vapor   = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  cloud   = make_array([1440,720,2], /float, value=!VALUES.F_NAN)
  rain    = make_array([1440,720,2], /float, value=!VALUES.F_NAN)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;determine if file exists
  exist=findfile(filename,count=num_found)
  if (num_found ne 1) then begin
    print, 'FILE NOT FOUND: ', filename
  endif else begin

    ;open file, read byte data, close file
    if strpos(filename, '.gz', 2, /reverse_offset) gt 0 then begin
      openr, file_ID, /get_lun, filename, error=err, /compress
    endif else begin
      openr, file_ID, /get_lun, filename, error=err
    endelse

    if (err gt 0) then begin
      print, 'ERROR OPENING FILE: ', filename
    endif else begin
      readu, file_ID, byte_data
      free_lun, file_ID
    endelse

    ; to decode byte data to real data
    scale  = [0.1, 0.15, .2, .2, .3,   .01, .1]
    offset = [0.0, -3.0, 0., 0., 0., -0.05, 0.]

    ;loop through asc/dsc passes and all 7 products
    for index_pass=0,1 do begin
      for index_product=0,6 do begin

        ;extract 1 product, scale and assign to real array
        dat = byte_data[*,*,index_product,index_pass]
        ok = where(dat le 250)
        dat = float(dat)
        dat[ok] = dat[ok] * scale[index_product] + offset[index_product]

        case index_product of
          0: time    [*,*,index_pass] = dat
          1: sst     [*,*,index_pass] = dat
          2: wind_lf [*,*,index_pass] = dat
          3: wind_mf [*,*,index_pass] = dat
          4: vapor   [*,*,index_pass] = dat
          5: cloud   [*,*,index_pass] = dat
          6: rain    [*,*,index_pass] = dat
        endcase

      endfor ;index_product
    endfor ;index_pass

  endelse


  return
  print,dat


end
