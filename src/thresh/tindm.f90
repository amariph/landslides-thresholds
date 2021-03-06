! PURPOSE: 
!	  writes Maximum precipitation threshold exceedance values to individual a single
!	  file per station
!
	
	subroutine tindm(ulog,uout,uout2,n,stationNumber,stationPtr,&
	year,month,day,hour,sumTantecedent,sumTrecent,intensity,duration,&
	deficit,intensityDuration,outputFolder,plotFile,stationLocation,in2mm,xid,AWI,&
	runningIntens,TavgIntensity,avgIntensity,Tantecedent,Trecent,precipUnit,&
        checkS,checkA)
	implicit none
	
! FORMAL ARGUMENTS
	integer, intent(in)  :: n,year(n),Tantecedent,Trecent
	integer, intent(in)  :: month(n),day(n),hour(n)
	integer, intent(in)  :: uout,ulog,stationPtr,uout2
	real, intent(in)     :: sumTantecedent(n),sumTrecent(n),intensity(n),in2mm
	real, intent(in)     :: duration(n),AWI(n),avgIntensity,TavgIntensity
	real, intent(in)     :: deficit(n),intensityDuration(n),runningIntens(n)
	character,intent(in) :: xid*(*)
	character,intent(in) :: outputFolder*(*),plotFile*(*),stationNumber*(*)
	character,intent(in) :: stationLocation*(*),precipUnit*(*)
        logical, intent(in)   :: checkS,checkA	

! LOCAL VARIABLES
	character (len=255) :: outputFile
	character (len=10)  :: date,anteced,recent,mintensity,mduration
	character (len=10)  :: mdeficit,mintensityDuration,mAWI,mrunningIntensity
	character (len=10)  :: logStormIntensity !logRunIntensity,
	character (len=8)   :: TavgIntensityF 
	character (len=3)   :: AntecedentHeader
	character 	    :: pd,tb,cbrai
	real	    	    :: maxDeficit,maxDuration,d_recent_antecedentmx,maxThreshIndex 
	integer		    :: j,k,hcnt,ist,ind,maxDefptr,maxDurptr,maxThInptr,un(2)

!------------------------------	
	
	pd=char(35) ! pound sign
	tb=char(9) ! tab character

! Set text for heading of Antecedent precipitation column
   	if(checkS) then
  	   AntecedentHeader='SAP' !Seasonal Antecedent Precipitation
        else if (checkA) then
           AntecedentHeader='AWI' !Antecedent Wetness Index
        else
           AntecedentHeader='CAP' !Cumulative Annual Precipitation
        end if

! Create output files
	
	outputFile=trim(adjustl(stationNumber))//'.txt'
  	outputFile=trim(outputFolder)//trim(plotFile)//trim(adjustl(xid))//outputFile
	open(uout,file=outputFile,status='unknown',position='rewind',err=125)
	
	outputFile=trim(adjustl(stationNumber))//'.txt'
  	outputFile=trim(outputFolder)//trim(plotFile)//trim(adjustl(xid))//'Ex'//outputFile
	open(uout2,file=outputFile,status='unknown',position='rewind',err=125)
     	
! Write heading if writing a new file (position=rewind); skip if appending to an old one.
        write(TavgIntensityF,'(F8.3)') TavgIntensity
        TavgIntensityF=adjustl(TavgIntensityF)
	un(1) = uout; un(2) = uout2
	  do k=1,2
	  write(un(k),*) pd,' Maximum Daily Values for Thresholds '
	  write(un(k),*) pd,' Station ',trim(stationNumber),': ',trim(stationLocation),&
            &' Precipitation units: ', precipUnit
	  write(un(k),*) pd,' Station ',tb,' Date',tb,Tantecedent,'-h precip.',&
            tb,Trecent,'-h precip.',tb,'RA Index',tb,&
	    'Intensity',tb,'Log10(Intensity)',tb,&
	    'Duration',tb,'ID Index',tb,&
	    AntecedentHeader,tb,trim(TavgIntensityF),'-h intensity',tb,&
	    'Combined RA and intensity index'
	  end do
	  
! find maximum daily value of threshold index & associated values	
	ist=1;ind=1;hcnt=1
	do k=1,stationPtr
	  if(day(ist)==day(k) .and. month(ist)==month(k)) then
	    hcnt=hcnt+1
	    ind=k
	  else ! find maximum duration & threshold index
	    maxDeficit=0.;maxDuration=0.;maxThreshIndex=0.
	    maxDefptr=ist;maxDurptr=ist;maxThInptr=ist
	    do j=ist,ind
	      if(deficit(j)>maxDeficit) then
	        maxDeficit=deficit(j)
	        maxDefptr=j
	      end if
	      
	      if(duration(j)>maxDuration) then
	        maxDuration=duration(j)
	        maxDurptr=j
	      end if
	      
	      if(runningIntens(j)>maxThreshIndex) then
	        maxThreshIndex=runningIntens(j)
	        maxThInptr=j
	      end if
	    end do
	    
!  Write data to text strings and trim blank spaces to reduce file size      
	    write(date,'(i2.2,a1,i2.2,a1,i4)')month(maxDefptr),'/',day(maxDefptr),'/',year(maxDefptr)
     	 write(anteced,'(f10.2)') sumTantecedent(maxDefptr)
     	 write(recent,'(f10.2)') sumTrecent(maxDefptr)
	    write(mdeficit,'(f10.3)') deficit(maxDefptr)
	    d_recent_antecedentmx=deficit(maxDefptr)
	    write(mintensityDuration,'(f10.3)') intensityDuration(maxDurptr)
     	 write(mduration,'(f10.1)') duration(maxDurptr)
     	 write(mintensity,'(f10.3)') intensity(maxDurptr)
     	    
	    if (intensity(maxDurptr)<=0) then
     	      write(logStormIntensity ,'(f10.3)') -99.
	    else
     	      write(logStormIntensity ,'(f10.3)') log10(intensity(maxDurptr))
	    end if
	    
	    write(mAWI,'(f10.3)') AWI(maxDurptr)
	    write(mrunningIntensity,'(f10.3)') runningIntens(maxThInptr)
!  Combined Recent/Antecedent Index & Intensity Index (cbrai)
	    if (d_recent_antecedentmx>0. .and. maxThreshIndex>avgIntensity) then
	      write (cbrai,'(i1)') 1
	    else
	      write (cbrai,'(i1)') 0
	    end if
	    
	    anteced              = trim(adjustl(anteced))
	    recent               = trim(adjustl(recent))
  	    mdeficit             = trim(adjustl(mdeficit))
	    mintensity           = trim(adjustl(mintensity))
	    logStormIntensity          = trim(adjustl(logStormIntensity))
	    mduration            = trim(adjustl(mduration))
	    mintensityDuration   = trim(adjustl(mintensityDuration))
	    mAWI                 = trim(adjustl(mAWI))
	    
	    write(uout,*) trim(stationNumber),tb,&
	                  date,tb,&
	                  anteced,tb,&
	                  recent,tb,&
	                  mdeficit,tb,&
	                  mintensity,tb,&
	                  logStormIntensity,tb,&
	                  mduration,tb,&
	                  mintensityDuration,tb,&
	                  mAWI,tb,&
	                  mrunningIntensity,tb,&
	                  cbrai
	                  
	    if(d_recent_antecedentmx>0.) write(uout2,*) trim(stationNumber),tb,&
	                                 date,tb,&
	                                 anteced,tb,&
	                                 recent,tb,&
	                                 mdeficit,tb,&
	                                 mintensity,tb,&
	                                 logStormIntensity,tb,&
	                                 mduration,tb,&
	                                 mintensityDuration,tb,&
	                                 mAWI,tb,&
	                                 mrunningIntensity,tb,&
	                                 cbrai
              
	    ist=k
	    hcnt=1
	  end if	  
	end do
	close(uout)
	write(*,*) ' Daily maximum threshold file finished'
	return
	
! DISPLAY ERROR MESSAGE
  125   write(ulog,*) 'Error opening file ',trim(outputFile)
  	close (ulog)
        write(*,*) 'Error opening file ',trim(outputFile	)
  	write(*,*) 'Press Enter key to exit program.'
  	read(*,*)
	stop
	end subroutine tindm
