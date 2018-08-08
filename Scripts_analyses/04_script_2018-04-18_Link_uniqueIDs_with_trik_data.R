
#loading libraries
#Author: Taariq
library(magrittr)
library(data.table)
library(Hmisc)
#clean dates in both datasets
library(lubridate)


#read in combined dataset with all monitors
#activity.dt <- fread("Data/2018-01-17_trik_dat_long.csv", header = TRUE, stringsAsFactors = FALSE)
activity.dt <- fread("../Data/raw/Trikinetics/02_2018-04-18_trik_dat_long.csv", header = TRUE,stringsAsFactors = FALSE)

#This isn't reading last row id:h12w5
#fly.dt <- fread("~/HahnLab/Circadian_rhythm_runs_seasonal_timing/Data/2018-01-26_rhagoletis_masterdata_data_slice.csv", header = TRUE, stringsAsFactors = FALSE)
fly.dt <- fread("../Data/2018-08-07_master_data_slice.csv", header = TRUE, stringsAsFactors = FALSE)
#fly.dt <- fly.dt[,c(23:39)] #limit to columns of interest
fly.dt <- fly.dt[,c(25:42)] #limit to columns of interest


#fly.dt <- subset(fly.dt, Trikinetics_monitor !="NA" )
fly.dt <- subset(fly.dt, Trik_monitor !="NA" )
#dim(fly.dt)
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
  #if(fly[,"Trikinetics_monitor"] %in% c(1,2) && !is.na(fly[,"Trikinetics_entry_LD_time"]))
  if(fly[,"Trik_monitor"] %in% c(1,2) && !is.na(fly[,"Trikinetics_entry_LD_time"]))
  {
    #subset activities to those for the appropriate monitor (for the fly's position)
    #activities <- subset(activities, monitor == fly[,"Trikinetics_monitor"])
    
    #trik_activities <- activities %>% subset(monitor == as.data.frame(fly)[,"Trikinetics_monitor"]) %>% subset(position == as.data.frame(fly)[,"Trikinetics_position"])
    trik_activities <- activities %>% subset(monitor == as.data.frame(fly)[,"Trik_monitor"]) %>% subset(position == as.data.frame(fly)[,"Trikinetics_position"])
    #create an interval object for the fly's time in the monitor
    current.fly.interval <- interval(fly$Trikinetics_entry_LD_time, fly$Trikinetics_exit_LD_time)
    
    #check for activities that happened in the specificed monitor/channel during current.fly.interval
    trik_activities <- trik_activities %>% subset(fulltime %within% current.fly.interval)
    trik_activities$experiment<-rep("entrainment", length(trik_activities$monitor))
  }
  if(fly[,"Free_run_trik_monitor"] %in% c(3,4,5,6) && !is.na(fly[,"Free_run_entry_time"]) && !is.na(fly[,"Free_run_trik_monitor"]))
  {
    #subset activities to those for the appropriate monitor (for the fly's position)
    fr_activities <- activities %>% subset(monitor == as.data.frame(fly)[,"Free_run_trik_monitor"]) %>% subset(position ==  as.data.frame(fly)[,"Free_run_trik_position"])
    
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
head(big_data)
dim(big_data)
summary(as.factor(big_data$monitor))
summary(as.factor(big_data$uniqueID))
#fwrite(big_data,"../Data/04_2018-04-19_unique_ID_trikinetics_behavioral_counts.csv")
#big_data$experiment %>% is.na() %>% as.numeric() %>% sum()

#Bin by 6 min, 15, min, 30 min, 60 min, 1 hr

big_data_flies = unique(big_data, by="uniqueID")

####Bin 6 min
time_bin_6min = list()

for (i in 1:nrow(big_data_flies))
{
  uniqueFly = big_data
  uniqueFly = subset(big_data, big_data$uniqueID == big_data_flies$uniqueID[i])
  sequence = seq(from = min(uniqueFly$fulltime), to=max(uniqueFly$fulltime), by="6 min")
  if(max(uniqueFly$fulltime) > max(sequence)) {
    sequence <- c(sequence, (max(sequence) + 6*60))
  }
  bins = cut(uniqueFly$fulltime, breaks = sequence)
  counts = as.data.frame(tapply(uniqueFly$counts, bins, sum))
  colnames(counts) = "Counts"
  time_bin_6min[[i]] = counts
  print(big_data_flies$uniqueID[i])
}

####Bin 15 min
time_bin_15min = list()

for (i in 1:nrow(big_data_flies))
{
  uniqueFly = big_data
  uniqueFly = subset(big_data, big_data$uniqueID == big_data_flies$uniqueID[i])
  sequence = seq(from = min(uniqueFly$fulltime), to=max(uniqueFly$fulltime), by="15 min")
  if(max(uniqueFly$fulltime) > max(sequence)) {
    sequence <- c(sequence, (max(sequence) + 15*60))
  }
  bins = cut(uniqueFly$fulltime, breaks = sequence)
  counts = as.data.frame(tapply(uniqueFly$counts, bins, sum))
  colnames(counts) = "Counts"
  time_bin_15min[[i]] = counts
  print(big_data_flies$uniqueID[i])
}

####Bin 30 min
time_bin_30min = list()

for (i in 1:nrow(big_data_flies))
{
  uniqueFly = big_data
  uniqueFly = subset(big_data, big_data$uniqueID == big_data_flies$uniqueID[i])
  sequence = seq(from = min(uniqueFly$fulltime), to=max(uniqueFly$fulltime), by="30 min")
  if(max(uniqueFly$fulltime) > max(sequence)) {
    sequence <- c(sequence, (max(sequence) + 30*60))
  }
  bins = cut(uniqueFly$fulltime, breaks = sequence)
  counts = as.data.frame(tapply(uniqueFly$counts, bins, sum))
  colnames(counts) <- "Counts"
  time_bin_30min[[i]] <- counts
  print(big_data_flies$uniqueID[i])
}

####Bin 60 min
time_bin_60min = list()

for (i in 1:nrow(big_data_flies))
{
  uniqueFly = big_data
  uniqueFly = subset(big_data, big_data$uniqueID == big_data_flies$uniqueID[i])
  sequence = seq(from = min(uniqueFly$fulltime), to=max(uniqueFly$fulltime), by="hour")
  if(max(uniqueFly$fulltime) > max(sequence)) {
    sequence <- c(sequence, (max(sequence) + 60*60))
  }
  bins = cut(uniqueFly$fulltime, breaks = sequence)
  counts = as.data.frame(tapply(uniqueFly$counts, bins, sum))
  colnames(counts) <- c("fulltime", "counts")
  time_bin_60min[[i]] = counts
  print(big_data_flies$uniqueID[i])
}
colnames <- c("fulltime", "counts")
lapply(time_bin_60min, setNames, colnames)




uniqueFly = big_data
uniqueFly = subset(big_data, big_data$uniqueID == big_data_flies$uniqueID[1])
sequence = seq(from = min(uniqueFly$fulltime), to=max(uniqueFly$fulltime), by="hour")
if(max(uniqueFly$fulltime) > max(sequence)) {
  sequence <- c(sequence, (max(sequence) + 60*60))
}
bins = cut(uniqueFly$fulltime, breaks = sequence)
bins = as.data.frame(tapply(uniqueFly$counts, bins, FUN=sum))
colnames(counts) <- c("fulltime", "counts")
final = counts
print(big_data_flies$uniqueID[i])
