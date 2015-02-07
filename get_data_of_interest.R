#
# Read data of interest from the file (subsetting data of interest).
#
# Peaking in to the dataset file reveals that :
#
# 1. The first two columns mark the time of the observation
# 2. Observations occur every minute from a starting date/time.
# 3. Assume that all time points (i.e minutes) are included even
# when an observation value is missing.
# 4. Assume we know the dataset's schema.

get_data_of_interest <- function(dataset_path,start_date,end_date,columns) {
    
    # Dataset's schema
    all_names = c("Date","Time",
                  "Global_active_power","Global_reactive_power",
                  "Voltage","Global_intensity",
                  "Sub_metering_1","Sub_metering_2","Sub_metering_3")
    all_classes = c(rep("character",2),rep("double",7))
    
    # Decide on using data.table or data.frames
    if("data.table" %in% rownames(installed.packages())) {
        # Using the data.table pkgs
        library(data.table)
        
        # first read two lines from the input file
        # to get the header and the first date
        first_line_dt <- fread(dataset_path,nrows=1)
        first_date_time <- with(first_line_dt, paste(Date,Time))
        fd_psx <- strptime(first_date_time,"%d/%m/%Y %H:%M:%S")
        
        # from the assumptions above we can calculate the first
        # occurance of the start date in the file. It's in the line
        # determined by numeric value of difftime(sd_psx,fd_psx,unit="min")
        diff_mins <- c()
        sd_psx <- strptime(start_date,"%d/%m/%Y %H:%M:%S")
        diff_mins[1] <- as.numeric(difftime(sd_psx,fd_psx,unit="min"))
        
        # do the same with the end time
        ed_psx <- strptime(end_date,"%d/%m/%Y %H:%M:%S")
        diff_mins[2] <- as.numeric(difftime(ed_psx,fd_psx,unit="min"))
        
        # subset on the columns need indexes
        idx <- match(columns,all_names)
        selected_names <- all_names[idx]
        
        # We read file by skipping diff_mins[1] lines and reading the next
        # diff_mins[2] - diffs_mins[1] + 1 lines
        data_of_interest_dt <- fread(dataset_path, 
                                  na.strings = c("?"),
                                  skip = diff_mins[1] + 1,
                                  nrows = diff_mins[2] - diff_mins[1] + 1,
                                  select = idx,
                                  colClasses =  all_classes)
        
        # set correct names
        setnames(data_of_interest_dt,selected_names)
        
        
        # if the selected names include Date and Time 
        # replace columns with the merged as.POSIXlt column DateTime
        if (all(c("Date","Time") %in% selected_names,TRUE)) {
            data_of_interest_dt[,`:=`(DateTime = as.POSIXct(
                paste(Date,Time), format="%d/%m/%Y %H:%M:%S"))]
            data_of_interest_dt[,Date:=NULL]
            data_of_interest_dt[,Time:=NULL]    
        }
        
        # return 
        return(data_of_interest_dt)
    } else {
        # Using standard data.frames
        
        # first read two lines from the input file
        # to get the header and the first date
        first_line_df <- read.csv2(dataset_path,nrows=1)
        col_names <- names(first_line_dt)
        first_date_time <- with(first_line_dt, paste(Date,Time))
        fd_psx <- strptime(first_date_time,"%d/%m/%Y %H:%M:%S")
        
        # from the assumptions above we can calculate the first
        # occurance of the start date in the file. It's in the line
        # determined by numeric value of difftime(sd_psx,fd_psx,unit="min")
        diff_mins <- c()
        sd_psx <- strptime(start_date,"%d/%m/%Y %H:%M:%S")
        diff_mins[1] <- as.numeric(difftime(sd_psx,fd_psx,unit="min"))
        
        # do the same with the end time
        ed_psx <- strptime(end_date,"%d/%m/%Y %H:%M:%S")
        diff_mins[2] <- as.numeric(difftime(ed_psx,fd_psx,unit="min"))
        
        # We read file by skipping diff_mins[1] lines and reading the next
        # diff_mins[2] - diffs_mins[1] + 1 lines
        data_of_interest_df <- read.csv(dataset_path,
                                        col.names = all_names,
                                        colClasses = all_classes,
                                        sep=";",
                                        header = FALSE,
                                        na.strings = c("?"),
                                        skip = diff_mins[1] + 1,
                                        nrows = diff_mins[2] - diff_mins[1] + 1)
        
        # subset on the columns need indexes
        idx <- match(columns,all_names)
        selected_names <- all_names[idx]
        data_of_interest_df <- data_of_interest_df[selected_names]
        
        # if the selected names include Date and Time 
        # replace columns with the merged as.POSIXlt column DateTime
        if (all(c("Date","Time") %in% selected_names,TRUE)) {
            data_of_interest_df$DateTime <- with(data_of_interest_df,
                                                 as.POSIXct(paste(Date,Time),
                                                            format="%d/%m/%Y %H:%M:%S"))
            data_of_interest_df$Date <- NULL
            data_of_interest_df$Time <- NULL
        }
        
        # return 
        return(data_of_interest_df)
    }
}