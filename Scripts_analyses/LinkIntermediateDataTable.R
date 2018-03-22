setwd("~/HahnLab/Circadian_rhythm_runs_seasonal_timing/")
library(magrittr)
library(data.table)

#read in combined dataset with all monitors
activity.dt <- fread("~/HahnLab/Circadian_rhythm_runs_seasonal_timing/Data/2018-01-17_trik_dat_long.csv", header = TRUE, stringsAsFactors = FALSE)

#This isn't reading last row id:h12w5
fly.dt <- fread("~/HahnLab/Circadian_rhythm_runs_seasonal_timing/Data/2018-01-26_rhagoletis_masterdata_data_slice.csv", header = TRUE, stringsAsFactors = FALSE)
fly.dt <- fly.dt[,c(23:39)] #limit to columns of interest

#clean dates in both datasets
library(lubridate)


fly.dt <- subset(fly.dt, Trikinetics_monitor !="NA" )
#convert date field from char --> date
#activity.dt$date <- ymd(activity.dt$date)#convert date field from char --> date
activity.dt$fulltime <- ymd_hms(activity.dt$fulltime, tz = "US/Eastern")


today <- Sys.Date() #for flies with no exit date, assume exit date is today
now <- Sys.time() #for flies with no exit time, assume exit date/time is right now

#replace NA times and dates with today/now
fly.dt$Trikinetic_exit_date[which(is.na(fly.dt$Trikinetic_exit_date) && !is.na(fly.dt$eclosion_date))] <- today
fly.dt$Trikinetics_exit_LD_time[which(is.na(fly.dt$Trikinetics_exit_LD_time) && !is.na(fly.dt$Trikinetics_entry_LD_time))] <- now
fly.dt$Free_run_exit_date[which(is.na(fly.dt$Free_run_exit_date) && !is.na(fly.dt$Free_run_entry_date))] <- today
fly.dt$Free_run_exit_time[which(is.na(fly.dt$Free_run_exit_time) && !is.na(fly.dt$Free_run_entry_time))] <- now


fly.dt$eclosion_date <- ymd(fly.dt$eclosion_date)
fly.dt$Trikinetic_exit_date <- ymd(fly.dt$Trikinetic_exit_date)
fly.dt$Free_run_entry_date <- ymd(fly.dt$Free_run_entry_date)
fly.dt$Free_run_exit_date <- ymd(fly.dt$Free_run_exit_date)
fly.dt$Trikinetics_entry_LD_time <- paste(fly.dt$eclosion_date, fly.dt$Trikinetics_entry_LD_time, sep = " ")
fly.dt$Trikinetics_entry_LD_time <- ymd_hm(fly.dt$Trikinetics_entry_LD_time, tz = "US/Eastern")
fly.dt$Trikinetics_exit_LD_time <- paste(fly.dt$Trikinetic_exit_date, fly.dt$Trikinetics_exit_LD_time, sep=" ")
fly.dt$Trikinetics_exit_LD_time <- ymd_hm(fly.dt$Trikinetics_exit_LD_time, tz = "US/Eastern")
fly.dt$Free_run_entry_time <- paste(fly.dt$Free_run_entry_date, fly.dt$Free_run_entry_time, sep = " ")
fly.dt$Free_run_entry_time <- ymd_hm(fly.dt$Free_run_entry_time, tz = "US/Eastern")
fly.dt$Free_run_exit_time <- paste(fly.dt$Free_run_exit_date, fly.dt$Free_run_exit_time, sep = " ")
fly.dt$Free_run_exit_time <- ymd_hm(fly.dt$Free_run_exit_time, tz = "US/Eastern")

###Use this to check NAs
#fly.dt$Free_run_exit_time %>% is.na() %>% as.numeric() %>% sum()

activity.int <- interval(start = min(activity.dt$fulltime), end=max(activity.dt$fulltime))
fly.dt <- subset(fly.dt, Trikinetics_entry_LD_time %within% activity.int)

match.activities <- function(fly, activities = activity.dt)
{
  activities = activity.dt
  trik_activities <- data.table()
  fr_activities <- data.table()
  if(fly[,"Trikinetics_monitor"] %in% c(1,2) && !is.na(fly[,"Trikinetics_entry_LD_time"]))
  {
    #subset activities to those for the appropriate monitor (for the fly's position)
    #activities <- subset(activities, monitor == fly[,"Trikinetics_monitor"])
    
    trik_activities <- activities %>% subset(monitor == as.data.frame(fly)[,"Trikinetics_monitor"]) %>% subset(position == as.data.frame(fly)[,"Trikinetics_position"])
    #create an interval object for the fly's time in the monitor
    current.fly.interval <- interval(fly$Trikinetics_entry_LD_time, fly$Trikinetics_exit_LD_time)
    
    #check for activities that happened in the specificed monitor/channel during current.fly.interval
    trik_activities <- trik_activities %>% subset(fulltime %within% current.fly.interval)
    trik_activities$experiment<-rep("entrainment", length(trik_activities$monitor))
  }
  if(fly[,"Free_run_monitor"] %in% c(3,4,5,6) && !is.na(fly[,"Free_run_entry_time"]) && !is.na(fly[,"Free_run_monitor"]))
  {
    #subset activities to those for the appropriate monitor (for the fly's position)
    fr_activities <- activities %>% subset(monitor == as.data.frame(fly)[,"Free_run_monitor"]) %>% subset(position ==  as.data.frame(fly)[,"Free_run_position"])
    
    #create an interval object for the fly's time in the monitor
    current.fly.interval <- interval(fly$Free_run_entry_time,
                                     fly$Free_run_exit_time)
    
    #check for activities that happened in the specificed monitor/channel during current.fly.interval
    fr_activities <- fr_activities %>% subset(fulltime %within% current.fly.interval)
    fr_activities$experiment<-rep("free run", length(fr_activities$monitor))
  }
  if (nrow(trik_activities) > 0 && nrow(fr_activities) > 0)
  {
    #append a column with the fly id to the activities
    trik_activities$uniqueID <- fly$uniqueID
    fr_activities$uniqueID <- fly$uniqueID
    return(rbind(trik_activities,fr_activities))
  }
  if (nrow(trik_activities) > 0 && nrow(fr_activities) == 0)
  {
    trik_activities$uniqueID <- fly$uniqueID
    return(trik_activities)
  }
  if (nrow(fr_activities) > 0 && nrow(trik_activities) == 0)
  {
    fr_activities$uniqueID <- fly$uniqueID
    return(fr_activities)
  }
  if (nrow(fr_activities) == 0 && nrow(trik_activities) == 0)
  {
    #vector <- append(vector, trik_activities$uniqueID)
    #return(warning("Could not find activities for this fly."))
    return(data.table())
  }
}
#mat <- data.table()
#mat <- match.activities(fly.dt[1,])
#breaks for fly 14,15,21-26 checked that the dates of its entrance are beyond the
#max for activities and skip it
datalist = list()
for (i in 1:nrow(fly.dt))
{
  #mat <- rbind(match.activities(fly.dt[i,]))
  #tmpdat <- fread(match.activities(fly.dt[5,]))
  #mat <- rbindlist(list(mat, tmpdat))
  datalist[[i]] <- match.activities(fly.dt[i,])
  print(fly.dt[i,]$uniqueID)
}

big_data = do.call(rbind, datalist)
big_data$experiment %>% is.na() %>% as.numeric() %>% sum()

