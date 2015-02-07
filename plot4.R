plot4 <- function() {
    
    # Get dataset path (download dataset if needed)
    source("get_dataset.R")
    dataset_path <- get_dataset()
    
    # Get data of interest
    source("get_data_of_interest.R")
    data <- get_data_of_interest(dataset_path,
                                 start_date = "01/02/2007 00:00:00",
                                 end_date = "02/02/2007 23:59:00", 
                                 columns = c("Date","Time",
                                             "Global_active_power",
                                             "Global_reactive_power",
                                             "Voltage",
                                             "Sub_metering_1",
                                             "Sub_metering_2",
                                             "Sub_metering_3"))
    
    # display histogram on screen
    par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
    with(data, {
        plot(x = DateTime, y = Global_active_power,type = "l",xlab="", ylab="Global Active Power")
        plot(x = DateTime, y = Voltage,type = "l",xlab="datetime", ylab="Voltage")
        {
            ylab <- "Energy sub metering"
            plot(x=DateTime, y= Sub_metering_1,type = "n",xlab="", ylab=ylab)
            lines(DateTime, Sub_metering_1, col = "black")
            lines(DateTime, Sub_metering_2, col = "red")
            lines(DateTime, Sub_metering_3, col = "blue")
            legend("topright", col = c("black", "red", "blue"),lty=c(1,1),
                   legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
        }
        plot(x = DateTime, y = Global_reactive_power,type = "l",xlab="datetime", ylab="Global reactive power")
    })
    
    # call copy2png to get the png file at the folders directory
    source("dev.copy2png.R")
    dev.copy2png("plot4.png")
}