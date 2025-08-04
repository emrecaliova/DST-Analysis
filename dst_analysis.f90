    !------------------------------------------------------------------------------
    ! Program: dst_anlys.f90
    ! Description: Program that analyzes working hours for daylight saving time
    !              It provides results based on time zones and working hours.
    !              This program allows you to determine optimal working hours.
    !              It can also be used for other purposes with minor modifications.
    !              Program outputs do not convey any definitive meaning.
    !              Inferences made from program outputs cannot be attributed to the
    !              person who wrote the program.
    !------------------------------------------------------------------------------
    ! Background and Developer Note:
    ! This program was developed by Emre Çalıova during undergraduate studies at
    ! Istanbul Technical University (ITU) as part of a research project investigating
    ! the impacts of Turkey's permanent daylight saving time (DST) policy.
    ! This program has been updated and provided for the GitHub repository. It may
    ! differ from the program used in the research.
    !
    ! In 2016, Turkey adopted permanent DST to make better use of daylight throughout
    ! the year. This policy shift raised public and academic interest, particularly
    ! regarding its implications on energy consumption, human circadian rhythms, and
    ! daily life schedules. Accurate computation of sunrise and sunset times became
    ! essential for these assessments.
    !
    ! This tool was created to support daylight saving time assessments by providing
    ! precise sun position calculations and darkness during working hours based on 
    ! geographic and temporal inputs.
    !
    ! The solar position calculations are based on methods from:
    ! - U.S. NOAA Solar Calculator
    ! - Astronomical Algorithms by Jean Meeus
    !
    !------------------------------------------------------------------------------
    ! ... rest of the Fortran code goes here ...
    !------------------------------------------------------------------------------
    !
    !> Input:
    !
    !  ***File Inputs:
    !  - cities.csv: contains the name, latitude, and longitude information of 
    !                settlements (such as cities).
    !                It is expected to be edited by the user before run the program.
    !
    !  ***Variable Inputs:
    !  - START_YEAR: Start year of the run period
    !  - END_YEAR: End year of the run period
    !  - FIRST_TIMEZONE: First value of the time zone for analysis
    !  - LAST_TIMEZONE: Last value of the time zone for analysis
    !  - TIMEZONE_STEP: Time zone period increment value
    !  - TOT_WORKING_HOURS: Total working hours in a day
    !  - FST_STRT_WORKING_HOURS_HH: Hours value of the first start time for the daily work period
    !  - FST_STRT_WORKING_HOURS_MM: Minutes value of the first start time for the daily work period
    !  - LAST_STRT_WORKING_HOURS_HH: Hours value of the last end time for the daily work period
    !  - LAST_STRT_WORKING_HOURS_MM: Minutes value of the last end time for the daily work period
    !  - WORKING_HOURS_START_STEP_VALUE: Step value for daily work period starting time
    !
    !------------------------------------------------------------------------------
    !
    !> Variables:
    !
    ! ***Main program variables:
    !- CITY: City names for import, export and matrix in type descriptions
    !- LATITUDE: Latitude value of the city for import, export and matrix in type descriptions
    !- LONGITUDE: Longitude value of the city for import, export and matrix in type descriptions
    !- TIMEZONE: Timezone for export and matrix in type descriptions
    !- YEAR: Year values for loop, export and matrix in type descriptions
    !- MONTH: Month values for loop, export and matrix in type descriptions
    !- DAY: Day values for loop, export and matrix in type descriptions
    !- STR_SRT: Sunrise time as string for export and matrix in type descriptions
    !- STR_SST: Sunset time as string for export and matrix in type descriptions
    !- STR_SWH: Daily working period start time as string for export and matrix in type descriptions
    !- STR_EWH: Daily working period end time as string for export and matrix in type descriptions
    !- STR_WORKINDARK: Time of working period in darkness as string for export and matrix in type descriptions
    !- STR_SLD: Sunlight duration as string for export and matrix in type descriptions
    !- STR_NTD: Nighttime duration as string for export and matrix in type descriptions
    !- STR_TOTAL_WORKINDARK: Total annual hours of working period in darkness as string for loop, export and matrix in type descriptions
    !- NROW_CITY: Number of city in cities information file
    !- READER_LINE: Line readed from cities information file
    !- CITY_NAME: Parsed city name get from subroutine
    !- LAT_STR: Parsed latitude value get from subroutine
    !- LON_STR: Parsed longitude value get from subroutine
    !- I_CITY: Used for city loop
    !- SWH_H_INT: Hour value of daily working period start time as integer
    !- SWH_M_INT: Minutes value of daily working period start time as integer
    !- SWH_M_REAL: Minutes value of daily working period start time as real number
    !- SWH_S_INT: Seconds value of daily working period start time as integer
    !- EWH_H_INT: Hour value of daily working period end time as integer
    !- EWH_M_INT: Minutes value of daily working period end time as integer
    !- EWH_M_REAL: Minutes value of daily working period end time as real number
    !- EWH_S_INT: Seconds value of daily working period end time as integer
    !- WORKINDARK_HH_INT: Hour value of time of working period in darkness as integer
    !- WORKINDARK_MM_INT: Minutes value of time of working period in darkness as integer
    !- WORKINDARK_MM_REAL: Minutes value of time of working period in darkness as real number
    !- WORKINDARK_SS_INT: Seconds value of time of working period in darkness as integer
    !- LAT: Latitude value of the city in loop for subroutine
    !- LON: Longitude value of the city in loop for subroutine
    !- TZ: Time zone value in loop for subroutine
    !- START_HOUR: First start time for the daily work period as real number for loop
    !- END_HOUR_LIMIT: Last end time for the daily work period as real number for loop
    !- SWH: Start time value in loop for the daily work periods
    !- EWH: End time value in loop for the daily work periods
    !- SRT: Sunrise time as real value in loop for subroutine
    !- SRT: Sunset time as real value in loop for subroutine
    !- WORKINDARK: Time of working period in darkness as real number for loop
    !- SRT_HH: Hours value of sunrise time as integer from subroutine
    !- SRT_MM: Minutes value of sunrise time as integer from subroutine
    !- SRT_SS: Seconds value of sunrise time as integer from subroutine
    !- FRAC_TO_HMS_FOR_SRT: Sunrise time as string from subroutine
    !- SST_HH: Hours value of sunset time as integer from subroutine
    !- SST_MM: Minutes value of sunset time as integer from subroutine
    !- SST_SS: Seconds value of sunset time as integer from subroutine
    !- FRAC_TO_HMS_FOR_SST: Sunset time as string from subroutine
    !- SLD_HH: Hours value of sunlight duration as integer from subroutine
    !- SLD_MM: Minutes value of sunlight duration as integer from subroutine
    !- SLD_SS: Seconds value of sunlight duration as integer from subroutine
    !- FRAC_TO_HMS_FOR_SLD: Sunlight duration as string from subroutine
    !- NTD_HH: Hours value of nighttime duration as integer from subroutine
    !- NTD_MM: Minutes value of nighttime duration as integer from subroutine
    !- NTD_SS: Seconds value of nighttime duration as integer from subroutine
    !- FRAC_TO_HMS_FOR_NTD: Nighttime duration as string from subroutine
    !- FRAC_TO_HMS_FOR_SWH: Start time as string in loop for the daily work periods
    !- FRAC_TO_HMS_FOR_EWH: End time as string in loop for the daily work periods
    !- FRAC_TO_HMS_FOR_WORKINDARK: Time of working period in darkness as string
    !- CSV_UNIT: Used to assign file numbers for export files
    !- WORKINDARK_SUM: Total annual hours of working period in darkness as real number

    !  ***subroutine parse_csv_line:
    !- line: Row value to parse (subprogram input purposes)
    !- city: City name parsed from the given line (subprogram output purposes)
    !- lat: Latitude value parsed from the given line (subprogram output purposes)
    !- lon: Longitude value parsed from the given line (subprogram output purposes)
    !
    !  ***function count_lines:
    !- filename: File name to count number of lines (function input purposes)
    !- num_lines: Number of lines in the given file (function output purposes)
    !
    !  ***subroutine solar_calc:
    !- LAT: Latitude value of the city (subprogram input purposes)
    !- LON: Longitude value of the city (subprogram input purposes)
    !- TIMEZONE: Time zone value (subprogram input purposes)
    !- YEAR: Year (subprogram input purposes)
    !- MONTH: Month (subprogram input purposes)
    !- DAY: Day (subprogram input purposes)
    !- SRT_HH: Hours value of sunrise time (subprogram output purposes)
    !- SRT_MM: Minutes value of sunrise time (subprogram output purposes)
    !- SRT_SS: Seconds value of sunrise time (subprogram output purposes)
    !- FRAC_TO_HMS_FOR_SRT: Sunrise time as string (subprogram output purposes)
    !- SST_HH: Hours value of sunset time (subprogram output purposes)
    !- SST_MM: Minutes value of sunset time (subprogram output purposes)
    !- SST_SS: Seconds value of sunset time (subprogram output purposes)
    !- FRAC_TO_HMS_FOR_SST: Sunset time as string (subprogram output purposes)
    !- SLD_HH: Hours value of sunlight duration (subprogram output purposes)
    !- SLD_MM: Minutes value of sunlight duration (subprogram output purposes)
    !- SLD_SS: Seconds value of sunlight duration (subprogram output purposes)
    !- FRAC_TO_HMS_FOR_SLD: Sunlight duration as string (subprogram output purposes)
    !- NTD_HH: Hours value of nighttime duration (subprogram output purposes)
    !- NTD_MM: Minutes value of nighttime duration (subprogram output purposes)
    !- NTD_SS: Seconds value of nighttime duration (subprogram output purposes)
    !- FRAC_TO_HMS_FOR_NTD: Nighttime duration as string (subprogram output purposes)
    !- PLMTHOUR: Hour value of time (past local midnight) as integer
    !- PLMTMINUTE: Minute value of time (past local midnight) as integer
    !- PLMTSECOND: Second value of time (past local midnight) as integer
    !- PLMTFRACTION: Past local midnight time as real
    !- PI: Number of Pi
    !- DEG180: Real Number of 180 degree
    !- DEGTORAD: Degree to radian conversion factor
    !- RADTODEG: Radian to degree conversion factor
    !- JD: Julian Day
    !- JC: Julian Century
    !- GMLS: Geometric mean longitude of the Sun in degree
    !- GMAS: Geometric mean anomaly of the Sun in degree
    !- EEO: Eccentricity earth orbit
    !- SEC: Sun's equation of center
    !- STGL: Sun's true geometric longitude in degree
    !- STA: Sun's true anomaly in degree
    !- SRV: Sun's radius vector (AU)s in radian
    !- SAL: The apperent longitude of the Sun in degree
    !- MOE: Mean obliquity of the ecliptic in degree
    !- OC: Obliquity correction in degree
    !- SRA: Right ascension of the apperent position of the Sun in degree
    !- SD: Declination d of the apperent position of the Sun in degree
    !- VARY: Variable of y calculated from obliquity correction
    !- ET: Equation of time in minutes
    !- HASR: Hour angle of sunrise in degree
    !- HASS: Hour angle of sunset in degree
    !- SN: Solar Noon at local solar time
    !- SRT: Sunrise time at local solar time 
    !- SST: Sunset time at local solar time
    !- SLD: Sunlight duration in minutes
    !- NTD: Nighttime duration in minutes
    !- TST: True solar time in minutes
    !- HA: Hour angle in degree
    !- SZA: Solar zenith angle in degree
    !- SEA: Solar elevation angle in degree
    !- AAR: Approximately atmospheric refraction in degree
    !- SECforAR: Solar elevation corrected for atmospheric refraction in degree
    !- SAA: Solar azimuth angle in degree which is clockwise from north
    !
    !  ***subroutine get_days_in_month:
    !- YEAR: Year (subprogram input purposes)
    !- MONTH: Month (subprogram input purposes)
    !- NDAY: Number of days for the given year and month (subprogram output purposes)
    !
    !------------------------------------------------------------------------------
    !> Output:
    !  ***File Inputs:
    !  - output.csv: contains cities name, timezones, years, months, days, time of 
    !                working period, daily sunrise time, daily sunset time, start 
    !                times of working periods, end times of working periods, daily  
    !                total time of working period in darkness, daily sunlight duratin
    !                and daily nighttime duration.
    !  - summary.csv: contains cities name, timezones, years, start times of working 
    !                 periods, end times of working periods, total annual hours of 
    !                 working period in darkness.
    !------------------------------------------------------------------------------
    
    
    program DST_ANLYS
    implicit none
    
    type :: CITY_INFO_TYPE
        character(len=24) :: CITY
        real :: LATITUDE
        real :: LONGITUDE
    end type CITY_INFO_TYPE
    type(CITY_INFO_TYPE), allocatable :: CITY_INFO_MTRX(:)

    type :: EXPORT_TYPE
        character(len=24) :: CITY
        real(kind=8) :: TIMEZONE
        integer :: YEAR
        integer :: MONTH
        integer :: DAY
        real(kind=8) :: TOT_WORKING_HOURS
        character(len=8) :: STR_SRT
        character(len=8) :: STR_SST
        character(len=8) :: STR_SWH
        character(len=8) :: STR_EWH
        character(len=8) :: STR_WORKINDARK
        character(len=8) :: STR_SLD
        character(len=8) :: STR_NTD
    end type EXPORT_TYPE
    type(EXPORT_TYPE), allocatable :: EXPORT_MTRX(:)
    type(EXPORT_TYPE), allocatable :: TEMP(:)

    type :: SUMMARY_TYPE
    character(len=24) :: CITY
    real(kind=8) :: TIMEZONE
    integer :: YEAR
    character(len=8) :: STR_SWH
    character(len=8) :: STR_EWH
    character(len=9) :: STR_TOTAL_WORKINDARK
    end type SUMMARY_TYPE
    type(SUMMARY_TYPE), allocatable :: SUMMARY_MTRX(:)
    type(SUMMARY_TYPE), allocatable :: TEMP_SUMMARY(:)
    
    integer :: i, ios
    integer :: NROW_CITY, START_YEAR, END_YEAR
    real(kind=8) :: FIRST_TIMEZONE, LAST_TIMEZONE, TIMEZONE_STEP, TOT_WORKING_HOURS
    real(kind=8) :: FST_STRT_WORKING_HOURS_HH, FST_STRT_WORKING_HOURS_MM
    real(kind=8) :: LAST_STRT_WORKING_HOURS_HH, LAST_STRT_WORKING_HOURS_MM
    real(kind=8) :: WORKING_HOURS_START_STEP_VALUE
    character(len=100) :: READER_LINE
    character(len=24) :: CITY_NAME
    character(len=20) :: LAT_STR, LON_STR
    integer :: I_CITY, YEAR, MONTH, DAY, NDAYS, SWH_H_INT, SWH_M_INT, EWH_H_INT, EWH_M_INT
    integer :: EWH_S_INT, SWH_S_INT
    integer :: WORKINDARK_HH_INT, WORKINDARK_MM_INT, WORKINDARK_SS_INT
    real(kind=8) :: SWH_M_REAL, EWH_M_REAL, WORKINDARK_MM_REAL
    real(kind=8) :: LAT, LON, TZ
    real(kind=8) :: START_HOUR, END_HOUR_LIMIT, SWH, EWH, SRT, SST, WORKINDARK
    integer :: SRT_HH, SRT_MM, SRT_SS
    integer :: SST_HH, SST_MM, SST_SS
    integer :: SLD_HH, SLD_MM, SLD_SS
    integer :: NTD_HH, NTD_MM, NTD_SS
    character(len=8) :: FRAC_TO_HMS_FOR_SRT, FRAC_TO_HMS_FOR_SST
    character(len=8) :: FRAC_TO_HMS_FOR_SLD, FRAC_TO_HMS_FOR_NTD
    character(len=8) :: FRAC_TO_HMS_FOR_SWH, FRAC_TO_HMS_FOR_EWH
    character(len=8) :: FRAC_TO_HMS_FOR_WORKINDARK
    integer :: CSV_UNIT
    real(kind=8) :: WORKINDARK_SUM
    character(len=9) :: STR_TOTAL_WORKINDARK

    ! Get number of rows for cities information file
    NROW_CITY = count_lines("cities.csv") - 1
    allocate(CITY_INFO_MTRX(NROW_CITY))

    ! Open cities information file and read
    open(unit=51, file="cities.csv", status="old", action="read")
    ! Skip header line
    read(51, '(A)') READER_LINE
    i = 0
    do
        read(51, '(A)', iostat=ios) READER_LINE
        if (ios /= 0) exit  ! end of file or error
        i = i + 1
        ! Split line at commas
        call parse_csv_line(trim(READER_LINE), CITY_NAME, LAT_STR, LON_STR)
        ! Assign to struct
        CITY_INFO_MTRX(i)%CITY = trim(adjustl(CITY_NAME))
        read(LAT_STR, *) CITY_INFO_MTRX(i)%LATITUDE
        read(LON_STR, *) CITY_INFO_MTRX(i)%LONGITUDE
    end do
    ! Close file "cities.csv"
    close(51)

    ! Set run periods
    START_YEAR = 2024
    END_YEAR = 2026
    FIRST_TIMEZONE = 2.0
    LAST_TIMEZONE = 3.0
    TIMEZONE_STEP = 0.5
    
    ! Work periods for a day
    TOT_WORKING_HOURS = 9.0
    FST_STRT_WORKING_HOURS_HH = 7.0
    FST_STRT_WORKING_HOURS_MM = 0.0
    LAST_STRT_WORKING_HOURS_HH = 18.0
    LAST_STRT_WORKING_HOURS_MM = 0.0
    WORKING_HOURS_START_STEP_VALUE = 0.5


    do I_CITY = 1, NROW_CITY
        LAT = CITY_INFO_MTRX(I_CITY)%LATITUDE
        LON = CITY_INFO_MTRX(I_CITY)%LONGITUDE
        print *, "Processing for ", trim(CITY_INFO_MTRX(I_CITY)%CITY)
        TZ = FIRST_TIMEZONE

        do while (TZ <= LAST_TIMEZONE + 0.0001)
            write(*,'(A, F4.1)') "  Process TimeZone: ", TZ
            START_HOUR = FST_STRT_WORKING_HOURS_HH + FST_STRT_WORKING_HOURS_MM / 60.0
            END_HOUR_LIMIT = LAST_STRT_WORKING_HOURS_HH + LAST_STRT_WORKING_HOURS_MM / 60.0
            SWH = START_HOUR

            do while (SWH + TOT_WORKING_HOURS <= END_HOUR_LIMIT + 0.0001)
                SWH_H_INT = int(SWH)
                SWH_M_REAL = (SWH - SWH_H_INT) * 60.0
                SWH_M_INT = int(SWH_M_REAL)
                SWH_S_INT = int((SWH_M_REAL - SWH_M_INT) * 60.0)
                write(FRAC_TO_HMS_FOR_SWH, '(I2.2, ":", I2.2, ":", I2.2)') SWH_H_INT, &
                    SWH_M_INT, SWH_S_INT
                EWH = SWH + TOT_WORKING_HOURS
                EWH_H_INT = int(EWH)
                EWH_M_REAL = (EWH - EWH_H_INT) * 60.0
                EWH_M_INT = int(EWH_M_REAL)
                EWH_S_INT = int((EWH_M_REAL - EWH_M_INT) * 60.0)
                write(FRAC_TO_HMS_FOR_EWH, '(I2.2, ":", I2.2, ":", I2.2)') EWH_H_INT, EWH_M_INT, EWH_S_INT
                write(*,'(A, F4.1, A, A, A, A)') "  Process TimeZone: ", TZ, "  Step: ", FRAC_TO_HMS_FOR_SWH, FRAC_TO_HMS_FOR_EWH

                do YEAR = START_YEAR, END_YEAR
                    WORKINDARK_SUM = 0.0

                    do MONTH = 1, 12
                        call get_days_in_month(YEAR, MONTH, NDAYS)

                        do DAY = 1, NDAYS
                            call solar_calc(LAT, LON, TZ, YEAR, MONTH, DAY, &
                                            SRT_HH, SRT_MM, SRT_SS, &
                                            SST_HH, SST_MM, SST_SS, &
                                            SLD_HH, SLD_MM, SLD_SS, &
                                            NTD_HH, NTD_MM, NTD_SS, &
                                            FRAC_TO_HMS_FOR_SRT, FRAC_TO_HMS_FOR_SST, FRAC_TO_HMS_FOR_SLD, FRAC_TO_HMS_FOR_NTD)
                            SRT = SRT_HH + SRT_MM / 60.0 + SRT_SS / (60 * 60)
                            SST = SST_HH + SST_MM / 60.0 + SST_SS / (60 * 60)
                            WORKINDARK = 0.0
                            if (SRT.gt.SWH) then
                                WORKINDARK = (SRT - SWH)
                            endif
                            if (SST.lt.EWH) then
                                WORKINDARK = WORKINDARK + (EWH - SST)
                            endif
                            WORKINDARK_SUM = WORKINDARK_SUM + WORKINDARK
                            WORKINDARK_HH_INT = int(WORKINDARK)
                            WORKINDARK_MM_REAL = (WORKINDARK - WORKINDARK_HH_INT) * 60.0
                            WORKINDARK_MM_INT = int(WORKINDARK_MM_REAL)
                            WORKINDARK_SS_INT = int((WORKINDARK_MM_REAL - WORKINDARK_MM_INT) * 60.0)
                            write(FRAC_TO_HMS_FOR_WORKINDARK, '(I2.2, ":", I2.2, ":", I2.2)') &
                                WORKINDARK_HH_INT, WORKINDARK_MM_INT, WORKINDARK_SS_INT
                            ! Resize the matrix to add elements
                            if (.not. allocated(EXPORT_MTRX)) then
                                allocate(EXPORT_MTRX(1))
                                i = 1
                            else
                                i = size(EXPORT_MTRX) + 1
                                TEMP = EXPORT_MTRX
                                deallocate(EXPORT_MTRX)
                                allocate(EXPORT_MTRX(i))
                                EXPORT_MTRX(1:i-1) = TEMP
                                deallocate(TEMP)
                            end if
                            EXPORT_MTRX(i)%CITY = CITY_INFO_MTRX(I_CITY)%CITY
                            EXPORT_MTRX(i)%TIMEZONE = TZ
                            EXPORT_MTRX(i)%YEAR = YEAR
                            EXPORT_MTRX(i)%MONTH = MONTH
                            EXPORT_MTRX(i)%DAY = DAY
                            EXPORT_MTRX(i)%TOT_WORKING_HOURS = TOT_WORKING_HOURS
                            EXPORT_MTRX(i)%STR_SRT = FRAC_TO_HMS_FOR_SRT
                            EXPORT_MTRX(i)%STR_SST = FRAC_TO_HMS_FOR_SST
                            EXPORT_MTRX(i)%STR_SWH = FRAC_TO_HMS_FOR_SWH
                            EXPORT_MTRX(i)%STR_EWH = FRAC_TO_HMS_FOR_EWH
                            EXPORT_MTRX(i)%STR_WORKINDARK = FRAC_TO_HMS_FOR_WORKINDARK
                            EXPORT_MTRX(i)%STR_SLD = FRAC_TO_HMS_FOR_SLD
                            EXPORT_MTRX(i)%STR_NTD = FRAC_TO_HMS_FOR_NTD
                        end do
                    
                    end do

                    WORKINDARK_HH_INT = int(WORKINDARK_SUM)
                    WORKINDARK_MM_REAL = (WORKINDARK_SUM - WORKINDARK_HH_INT) * 60.0
                    WORKINDARK_MM_INT = int(WORKINDARK_MM_REAL)
                    WORKINDARK_SS_INT = int((WORKINDARK_MM_REAL - WORKINDARK_MM_INT) * 60.0)
                    write(STR_TOTAL_WORKINDARK, '(I0, ":", I2.2, ":", I2.2)') &
                        WORKINDARK_HH_INT, WORKINDARK_MM_INT, WORKINDARK_SS_INT
                    ! Add values to summary matrix
                    if (.not. allocated(SUMMARY_MTRX)) then
                        allocate(SUMMARY_MTRX(1))
                        i = 1
                    else
                        i = size(SUMMARY_MTRX) + 1
                        TEMP_SUMMARY = SUMMARY_MTRX
                        deallocate(SUMMARY_MTRX)
                        allocate(SUMMARY_MTRX(i))
                        SUMMARY_MTRX(1:i-1) = TEMP_SUMMARY
                        deallocate(TEMP_SUMMARY)
                    end if
                    SUMMARY_MTRX(i)%CITY = CITY_INFO_MTRX(I_CITY)%CITY
                    SUMMARY_MTRX(i)%TIMEZONE = TZ
                    SUMMARY_MTRX(i)%YEAR = YEAR
                    SUMMARY_MTRX(i)%STR_SWH = FRAC_TO_HMS_FOR_SWH
                    SUMMARY_MTRX(i)%STR_EWH = FRAC_TO_HMS_FOR_EWH
                    SUMMARY_MTRX(i)%STR_TOTAL_WORKINDARK = STR_TOTAL_WORKINDARK
                end do

                SWH = SWH + WORKING_HOURS_START_STEP_VALUE
            end do

            TZ = TZ + TIMEZONE_STEP
        end do
    
    end do


    open(newunit=CSV_UNIT, file="output.csv", status="replace", action="write")

    ! Header row
    write(CSV_UNIT, '(A)') "CITY,TIMEZONE,YEAR,MONTH,DAY,TOT_WORKING_HOURS," // &
                        "STR_SRT,STR_SST,STR_SWH,STR_EWH,STR_WORKINDARK," // &
                        "STR_SLD,STR_NTD"
    
    do i = 1, size(EXPORT_MTRX)
        write(CSV_UNIT, '(A,",",F5.1,",",I4,",",I2,",",I2,",",F6.2,",",A,",",A,",",A,",",A,",",A,",",A,",",A)') &
            trim(EXPORT_MTRX(i)%CITY), EXPORT_MTRX(i)%TIMEZONE, EXPORT_MTRX(i)%YEAR, EXPORT_MTRX(i)%MONTH, EXPORT_MTRX(i)%DAY, &
            EXPORT_MTRX(i)%TOT_WORKING_HOURS, &
            EXPORT_MTRX(i)%STR_SRT, EXPORT_MTRX(i)%STR_SST, EXPORT_MTRX(i)%STR_SWH, EXPORT_MTRX(i)%STR_EWH, &
            EXPORT_MTRX(i)%STR_WORKINDARK, EXPORT_MTRX(i)%STR_SLD, EXPORT_MTRX(i)%STR_NTD
    end do

    close(CSV_UNIT)

    open(newunit=CSV_UNIT, file="summary.csv", status="replace", action="write")

    ! Header row
    write(CSV_UNIT, '(A)') "CITY,TIMEZONE,YEAR,STR_SWH,STR_EWH,STR_TOTAL_WORKINDARK"

    do i = 1, size(SUMMARY_MTRX)
        write(CSV_UNIT, '(A,",",F5.1,",",I4,",",A,",",A,",",A)') &
            trim(SUMMARY_MTRX(i)%CITY), SUMMARY_MTRX(i)%TIMEZONE, SUMMARY_MTRX(i)%YEAR, &
            SUMMARY_MTRX(i)%STR_SWH, SUMMARY_MTRX(i)%STR_EWH, SUMMARY_MTRX(i)%STR_TOTAL_WORKINDARK
    end do

    close(CSV_UNIT)


    !===============================
    ! Deallocate memory (clean-up)
    !===============================
    if (allocated(CITY_INFO_MTRX))      deallocate(CITY_INFO_MTRX)
    if (allocated(EXPORT_MTRX))         deallocate(EXPORT_MTRX)
    if (allocated(TEMP))                deallocate(TEMP)
    if (allocated(SUMMARY_MTRX))        deallocate(SUMMARY_MTRX)
    if (allocated(TEMP_SUMMARY))        deallocate(TEMP_SUMMARY)
    !===============================

    !Sub programs and function
    contains

    subroutine parse_csv_line(line, city, lat, lon)
        character(len=*), intent(in) :: line
        character(len=24), intent(out) :: city
        character(len=20), intent(out) :: lat, lon
        integer :: p1, p2

        p1 = index(line, ',')
        p2 = index(line(p1+1:), ',') + p1
        city = line(1:p1-1)
        lat  = line(p1+1:p2-1)
        lon  = line(p2+1:)
    end subroutine parse_csv_line

    function count_lines(filename) result(num_lines)
        character(len=*), intent(in) :: filename
        integer :: num_lines, ios
        character(len=200) :: line
        integer :: unit

        num_lines = 0
        open(newunit=unit, file=filename, status='old', action='read')
        do
            read(unit, '(A)', iostat=ios) line
            if (ios /= 0) exit
            num_lines = num_lines + 1
        end do
        close(unit)
    end function count_lines

    subroutine solar_calc(LAT, LON, TIMEZONE, YEAR, MONTH, DAY, &
        SRT_HH, SRT_MM, SRT_SS, &
        SST_HH, SST_MM, SST_SS, &
        SLD_HH, SLD_MM, SLD_SS, &
        NTD_HH, NTD_MM, NTD_SS, &
        FRAC_TO_HMS_FOR_SRT, FRAC_TO_HMS_FOR_SST, FRAC_TO_HMS_FOR_SLD, FRAC_TO_HMS_FOR_NTD)

    implicit none

    ! Inputs
    real(kind=8), intent(in) :: LAT, LON, TIMEZONE
    integer, intent(in) :: YEAR, MONTH, DAY

    ! Outputs
    integer, intent(out) :: SRT_HH, SRT_MM, SRT_SS
    integer, intent(out) :: SST_HH, SST_MM, SST_SS
    integer, intent(out) :: SLD_HH, SLD_MM, SLD_SS
    integer, intent(out) :: NTD_HH, NTD_MM, NTD_SS
    character(len=8), intent(out) :: FRAC_TO_HMS_FOR_SRT, FRAC_TO_HMS_FOR_SST
    character(len=8), intent(out) :: FRAC_TO_HMS_FOR_SLD, FRAC_TO_HMS_FOR_NTD

    ! Local variables
    real(kind=8) :: PLMTHOUR, PLMTMINUTE, PLMTSECOND, PLMTFRACTION
    real(kind=8) :: PI, DEG180, DEGTORAD, RADTODEG
    integer :: JDY, JDM, A, B
    real(kind=8) :: JD, JDD, JC, GMLS, GMAS, EEO, SEC
    real(kind=8) :: STGL, STA, SRV, SAL, MOE, OC, SRA, SD, VARY
    real(kind=8) :: ET, HASR, HASS, SN, SRT, SST, SLD, NTD
    real(kind=8) :: TST, HA, SZA, SEA, AAR, SECforAR, SAA
    real(kind=8) :: SRT_TOT_SECs, SST_TOT_SECs, SLD_TOT_SECs, NTD_TOT_SECs

    PLMTHOUR = 12
    PLMTMINUTE = 0
    PLMTSECOND = 0
    PLMTFRACTION = (PLMTHOUR + PLMTMINUTE / 60.0d0 + PLMTSECOND / 3600.0d0) / 24.0d0

    PI = 3.14159265358979323846d0
    DEG180 = 180.0d0
    DEGTORAD = PI / DEG180
    RADTODEG = DEG180 / PI

    JDY = YEAR
    JDM = MONTH
    JDD = real(DAY, kind=8)
    if (MONTH <= 2) then
        JDY = JDY - 1
        JDM = JDM + 12
    end if
    A = JDY / 100
    B = 2 - A + A / 4
    JD = floor(365.25d0 * (JDY + 4716)) + floor(30.6001d0 * (JDM + 1)) + JDD + B - 1524.5d0
    JC = (JD - 2451545.0d0) / 36525.0d0
    GMLS = mod(280.46646d0 + JC * (36000.76983d0 + JC * 0.0003032d0), 360.0d0)
    GMAS = 357.52911d0 + JC * (35999.05029d0 - 0.0001537d0 * JC)
    EEO = 0.016708634d0 - JC * (0.000042037d0 + 0.0000001267d0 * JC)
    SEC = sin(GMAS * DEGTORAD) * (1.914602d0 - JC * (0.004817d0 + 0.000014d0 * JC)) + &
            sin(2.0d0 * GMAS * DEGTORAD) * (0.019993d0 - 0.000101d0 * JC) + &
            sin(3.0d0 * GMAS * DEGTORAD) * 0.000289d0
    STGL = GMLS + SEC
    STA = GMAS + SEC
    SRV = 1.000001018d0 * (1.0d0 - EEO * EEO) / (1.0d0 + EEO * cos(DEGTORAD * STA))
    SAL = STGL - 0.00569d0 - 0.00478d0 * sin(DEGTORAD * (125.04d0 - 1934.136d0 * JC))
    MOE = 23.0d0 + (26.0d0 + (21.448d0 - JC * (46.815d0 + JC * (0.00059d0 - JC * 0.001813d0))) / 60.0d0) / 60.0d0
    OC = MOE + 0.00256d0 * cos(DEGTORAD * (125.04d0 - 1934.136d0 * JC))
    SRA = RADTODEG * atan2(cos(DEGTORAD * OC) * sin(DEGTORAD * SAL), cos(DEGTORAD * SAL))
    SD = RADTODEG * asin(sin(DEGTORAD * OC) * sin(DEGTORAD * SAL))
    VARY = tan(DEGTORAD * (OC / 2.0d0))**2
    ET = 4.0d0 * RADTODEG * (VARY * sin(2.0d0 * DEGTORAD * GMLS) - 2.0d0 * EEO * sin(DEGTORAD * GMAS) + &
        4.0d0 * EEO * VARY * sin(DEGTORAD * GMAS) * cos(2.0d0 * DEGTORAD * GMLS) - &
        0.5d0 * VARY**2 * sin(4.0d0 * DEGTORAD * GMLS) - 1.25d0 * EEO**2 * sin(2.0d0 * DEGTORAD * GMAS))
    HASR = RADTODEG * acos(cos(DEGTORAD * 90.833d0) / (cos(DEGTORAD * LAT) * cos(DEGTORAD * SD)) - &
            tan(DEGTORAD * LAT) * tan(DEGTORAD * SD))
    HASS = -HASR
    SN = (720.0d0 - 4.0d0 * LON - ET + TIMEZONE * 60.0d0) / 1440.0d0
    SRT = (SN * 1440.0d0 - HASR * 4.0d0) / 1440.0d0
    SST = (SN * 1440.0d0 - HASS * 4.0d0) / 1440.0d0
    SLD = 8.0d0 * HASR
    NTD = 1440.0d0 - SLD
    TST = mod((PLMTFRACTION * 1440 + ET + 4 * LON - 60 * TIMEZONE), 1440.0)
    if (TST/4.0.lt.0) then
    HA = TST / 4.0 + 180.0
    else
    HA = TST / 4.0 - 180.0
    endif
    SZA = RADTODEG * (acos(sin(DEGTORAD * LAT) * sin(DEGTORAD * SD) &
    + cos(DEGTORAD * LAT) * cos(DEGTORAD * SD) * cos(DEGTORAD * HA)))
    SEA = 90 - SZA
    if (SEA.gt.85) then
    AAR = 0
    elseif (SEA.gt.5) then
    AAR = (58.1 / tan(DEGTORAD * SEA) - 0.07 / tan(DEGTORAD * SEA)**3 &
    + 0.000086 / tan(DEGTORAD * SEA)**5) / 3600
    elseif (SEA.gt.-0.575) then
    AAR = (1735 + SEA * (-518.2 + SEA * (103.4 + SEA * &
    (-1279 + SEA * 0.711)))) / 3600
    else
    AAR = -20.772 / tan(DEGTORAD * SEA) / 3600
    endif
    SECforAR = SEA + AAR
    if (HA.gt.0.0) then
    SAA = mod((RADTODEG * acos( &
        (sin(DEGTORAD * LAT) * cos(DEGTORAD * SZA) - sin(DEGTORAD * SD)) / &
        (cos(DEGTORAD * LAT) * sin(DEGTORAD * SZA)) )) + 180.0, 360.0)
    else
    SAA = mod(540.0 - (RADTODEG * acos( &
        (sin(DEGTORAD * LAT) * cos(DEGTORAD * SZA) - sin(DEGTORAD * SD)) / &
        (cos(DEGTORAD * LAT) * sin(DEGTORAD * SZA)) )), 360.0)
    end if
    SRT_TOT_SECs = SRT * 86400.0d0
    SST_TOT_SECs = SST * 86400.0d0
    SLD_TOT_SECs = SLD * 60.0d0
    NTD_TOT_SECs = NTD * 60.0d0
    SRT_HH = int(SRT_TOT_SECs / 3600.0d0)
    SRT_MM = int(mod(SRT_TOT_SECs, 3600.0d0) / 60.0d0)
    SRT_SS = int(mod(SRT_TOT_SECs, 60.0d0) + 0.5d0)
    write(FRAC_TO_HMS_FOR_SRT, '(I2.2, ":", I2.2, ":", I2.2)') SRT_HH, SRT_MM, SRT_SS
    SST_HH = int(SST_TOT_SECs / 3600.0d0)
    SST_MM = int(mod(SST_TOT_SECs, 3600.0d0) / 60.0d0)
    SST_SS = int(mod(SST_TOT_SECs, 60.0d0) + 0.5d0)
    write(FRAC_TO_HMS_FOR_SST, '(I2.2, ":", I2.2, ":", I2.2)') SST_HH, SST_MM, SST_SS
    SLD_HH = int(SLD_TOT_SECs / 3600.0d0)
    SLD_MM = int(mod(SLD_TOT_SECs, 3600.0d0) / 60.0d0)
    SLD_SS = int(mod(SLD_TOT_SECs, 60.0d0) + 0.5d0)
    write(FRAC_TO_HMS_FOR_SLD, '(I2.2, ":", I2.2, ":", I2.2)') SLD_HH, SLD_MM, SLD_SS
    NTD_HH = int(NTD_TOT_SECs / 3600.0d0)
    NTD_MM = int(mod(NTD_TOT_SECs, 3600.0d0) / 60.0d0)
    NTD_SS = int(mod(NTD_TOT_SECs, 60.0d0) + 0.5d0)
    write(FRAC_TO_HMS_FOR_NTD, '(I2.2, ":", I2.2, ":", I2.2)') NTD_HH, NTD_MM, NTD_SS

    end subroutine solar_calc



    subroutine get_days_in_month(YEAR, MONTH, NDAYS)
    implicit none
    integer, intent(in) :: YEAR, MONTH
    integer, intent(out) :: NDAYS
    logical :: is_leap

    is_leap = (mod(YEAR,4) == 0 .and. mod(YEAR,100) /= 0) .or. (mod(YEAR,400) == 0)

    select case (MONTH)
    case (1,3,5,7,8,10,12)
        NDAYS = 31
    case (4,6,9,11)
        NDAYS = 30
    case (2)
        if (is_leap) then
            NDAYS = 29
        else
            NDAYS = 28
        end if
    end select

    end subroutine get_days_in_month


    end program DST_ANLYS