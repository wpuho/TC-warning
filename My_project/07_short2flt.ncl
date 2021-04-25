load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

diri = "./"
fili = "02_namelist.input"
pthi = diri+fili

input_file = keyword_values(pthi,"NCL_INPUT","string")

;lat = keyword_values(pthi,"LAT_NAME","string")
;lon = keyword_values(pthi,"LON_NAME","string")
;input_data = keyword_values(pthi,"INPUT_DATA","string")
;input_mask = keyword_values(pthi,"INPUT_MASK","string")

;print(input_file)
;print(latitude)
;print(longitude)
;print(input_data)
;print(input_mask)

;print(lat)

ncfile = addfile(input_file,"r")

lat = ncfile ->lat
lon = ncfile ->lon

masked = toint(ncfile ->mask)

analysed_sst = short2flt(ncfile ->analysed_sst)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

output_file = keyword_values(pthi,"SST_FILE","string")
output_date = output_file
output_file = output_file+".nc"

system("/bin/rm  "+output_file)

setfileoption("nc","Format","netcdf4")
ncdf = addfile(output_file,"c")

fAtt                            = True
fAtt@title                      = " .nc file created by myself"
fAtt@creation_date              = output_date

fileattdef(ncdf,fAtt)

ncdf ->lon = lon
ncdf ->lat = lat

ncdf ->analysed_sst = analysed_sst
ncdf ->mask = masked
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end
