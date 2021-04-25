        program MAKEnamelist
        implicit none
!============================
        integer           ::  nlons = 1440,nlats = 720,ntimes = 1
        character(len=3)  ::  lat_name = 'lat'
        character(len=3)  ::  lon_name = 'lon'
        character(len=12) ::  input_data = 'analysed_sst'
        character(len=6)  ::  input_mask = 'mask'
!============================
        character(len=8) ::  NCL_input = "OISST.nc"
!============================
        character(len=8)  ::  sst_file = "20200901"
!============================
        character(len=15) ::  For_TC_track = "wp1120_0901.tcw"
        character(len=5)  ::  label_prvs = "RIGHT",label_fcst = "RIGHT"
!============================
        character(len=8)  ::  plot_input1 = "20200901"
        character(len=5)  ::  plot_input2 = "track"
        character(len=8)  ::  plot_output = "20200901"
        character(len=7)  ::  TC_type = "TYPHOON"
        character(len=3)  ::  TC_No = "11W"
        character(len=6)  ::  TC_name = "HAISHEN"
        character(len=2)  ::  TC_warning = "09"
!============================

        namelist /INPUT_DATA_SET/ nlons,nlats,ntimes,lat_name,lon_name,&
&input_data,input_mask

        namelist /INPUT_FOR_NCL/ NCL_input

        namelist /INPUT_SST_FILE/ sst_file

        namelist /INPUT_FOR_TRACK/ For_TC_track,label_prvs,label_fcst

        namelist /INPUT_FOR_PLOT/ plot_input1,plot_input2,plot_output,&
&TC_type,TC_No,TC_name,TC_warning

!============================

        open(10,file="namelist.input")
        
        write(10,nml=INPUT_DATA_SET)
        write(10,nml=INPUT_FOR_NCL)
        write(10,nml=INPUT_SST_FILE)
        write(10,nml=INPUT_FOR_TRACK)
        write(10,nml=INPUT_FOR_PLOT)

        close(10)

!============================
        end program MAKEnamelist
