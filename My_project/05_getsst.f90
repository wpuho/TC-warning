        program getsst

          use netcdf

        implicit none

        integer :: i,j,t
        integer :: ilen
        character(len=8) :: sst_file
        character(len=50) :: output_name


        integer :: nlons
        integer :: nlats
        integer :: ntimes

        character(len=50) :: input_name
        character(len=20) :: lat_name
        character(len=20) :: lon_name
        character(len=20) :: input_data
        character(len=20) :: input_mask

        integer :: ncid
        integer :: lat_varid,lon_varid
        integer :: data_varid,mask_varid
        integer :: start(2)

        real,allocatable :: lats(:),lons(:)
        real,allocatable :: sst(:,:,:)       
        integer,allocatable :: mask(:,:,:)
        real :: mask_value 
      
!================= READ NAMELIST ================

        namelist /INPUT_DATA_SET/ nlons,nlats,ntimes,lat_name,lon_name,&
&input_data,input_mask
        namelist /INPUT_SST_FILE/ sst_file

        open(11,file='02_namelist.input',status='old')

        read(11,nml=INPUT_DATA_SET)
        read(11,nml=INPUT_SST_FILE)

        close(11)

        allocate(lats(nlats))
        allocate(lons(nlons))
        allocate(sst(nlons,nlats,ntimes))
        allocate(mask(nlons,nlats,ntimes))

!============= NCL GENERATE SST DATA ============

        call system("ncl 07_short2flt.ncl")

        print*,' '
        print*,'New nc file successfully generated !!'
        print*,' '

!================= READ SST DATA ================

        print*,'Creating *.txt and *.mask files ...'

        ilen = len_trim(sst_file)

        input_name = sst_file(1:ilen)//'.nc'
        
        call check(nf90_open(input_name,nf90_nowrite,ncid))
        
        call check(nf90_inq_varid(ncid,lat_name,lat_varid))
        call check(nf90_inq_varid(ncid,lon_name,lon_varid))
        call check(nf90_inq_varid(ncid,input_data,data_varid))
        call check(nf90_inq_varid(ncid,input_mask,mask_varid))

        start = (/1, 1/)

        call check(nf90_get_var(ncid,lat_varid,lats,start))
        call check(nf90_get_var(ncid,lon_varid,lons,start))
        call check(nf90_get_var(ncid,data_varid,sst,start))
        call check(nf90_get_var(ncid,mask_varid,mask,start))

        sst = sst - 273.15
        mask_value = -999.

        open(21,file=sst_file(1:ilen)//'.txt',form='formatted')
        open(31,file=sst_file(1:ilen)//'.mask',form='formatted')

        do t = 1,ntimes
        do i = 1,nlons
        do j = 1,nlats

          if (mask(i,j,t).eq.65) then

            write(21,'(F10.3,F9.3,F9.3)') lons(i),lats(j),sst(i,j,t)

          !else if ((mask(i,j,t).eq.2).or.(mask(i,j,t).eq.3)) then
          else

            !write(21,'(F10.3,F9.3,F10.3)') lons(i),lats(j),mask_value
            write(31,'(F10.3,F9.3,F8.1)') lons(i),lats(j)

          end if

        enddo
        enddo
        enddo

        close(21)
        close(31)

!================================================

        contains

          subroutine check(status)
          integer, intent(in) :: status

          if(status /= nf90_noerr) then

            print *, trim(nf90_strerror(status))
            stop "Stopped"

          end if

          end subroutine check

!================================================

        end program getsst

!gfortran ReadSST.f90 -o ReadSST `nf-config --fflags --flibs`
