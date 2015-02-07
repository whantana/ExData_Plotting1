plot3 <- function() {
    
    # Get dataset path (download dataset if needed)
    source("get_dataset.R")
    dataset_path <- get_dataset()
    
    # Get data of interest
    source("get_data_of_interest.R")
    data <- get_data_of_interest(dataset_path,
                                 start_date = "01/02/2007 00:00:00",
                                 end_date = "02/02/2007 23:59:00", 
                                 columns = c("Date","Time",
                                             "Sub_metering_1",
                                             "Sub_metering_2",
                                             "Sub_metering_3"))
    
    # display histogram on screen
    ylab <- "Energy sub metering"
    with(data,plot(x=DateTime, y= Sub_metering_1,type = "n",
                   xlab="", ylab=ylab))
    with(data,lines(DateTime, Sub_metering_1, col = "black"))
    with(data,lines(DateTime, Sub_metering_2, col = "red"))
    with(data,lines(DateTime, Sub_metering_3, col = "blue"))
    legend("topright", col = c("black", "red", "blue"),lty=c(1,1),
           legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
    
    # call copy2png to get the png file at the folders directory
    source("dev.copy2png.R")
    dev.copy2png("plot3.png")
}