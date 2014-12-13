readRAWS = function(){
  ## readRAWS.R
  ## by Lorenzo Booth
  ## WARNING: parentDir is described below
  ## WARNING: This directory must have the readRAWS.R file inside it!
  ## WARNING: Function contains a for loop, sorry!
  ##
  ## This function expects to be run in a parent folder containing subfolders which, in turn
  ## contain a list of csv files containing Remote Automated Weather Station (RAWS) data.
  ## The following folder heirarchy IS EXPECTED:
  ##   ------------
  ##  | Parent_Dir |
  ##      |   -------------------
  ##      -> | RAWS_Station_Name |
  ##            |
  ##            -> RAWSname_Year[1].csv
  ##            -> RAWSname_Year[1].csv
  ##            -> ...
  ##      |   -------------------
  ##      -> | RAWS_Station_Name |
  ##      |
  ##      -> ...
  ##
  ## In each csv file we expect 6 columnns named as follows:
  ## 'date_time' containing the date/time information in the following format: [YYYY-MM-DD HH:MM:SS]
  ## 'Speed' containing wind speed data in meters per second
  ## 'Direc' containing wind speed direction in degrees from north
  ## 'Temp' containing average air temperatures in degrees Celsius
  ## 'Rad.' is average solar irradiance in units of watts/(meter^2)
  ##
  ## FINAL WARNING: A lot of things are hardcoded in this kludgy script.
  ## Any other formatting is untested and may result in outstandingly spectacular errors.
  
  dirs = list.dirs()[-1]  # Get directories from working directory and exclude root dir

  for (item in dirs) {
    setwd(item)
    csvfiles = list.files()
    result = do.call(rbind, lapply(csvfiles, function(x) {read.csv(x, header=TRUE)}))
    result$date_time = as.POSIXct(result$date_time,format="%Y-%m-%d %H:%M:%S")
    result$monthYr = strftime(result$date_time, format="%Y/%m")
    result[result == -999] = NA
    
    # Output the file
    setwd('..')
    # filename = paste(item,substr(head(csvfiles, n=1), nchar(tail(csvfiles, n=1))-5, nchar(tail(csvfiles, n=1))-4),substr(tail(csvfiles, n=1), nchar(tail(csvfiles, n=1))-5, nchar(tail(csvfiles, n=1))-4),sep='')
    assign(substr(item,3,nchar(item)),result) #assigns the result to the item name
    save(list=substr(item,3,nchar(item)),file=paste(item,'.Rda',sep='')) #saves the previously created variable
  }
  
}