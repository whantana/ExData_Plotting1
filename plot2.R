plot2 <- function() {
    
    # Get dataset path (download dataset if needed)
    source("get_dataset.R")
    dataset_path <- get_dataset()
    
    # Get data of interest
    source("get_data_of_interest.R")
    data <- get_data_of_interest(dataset_path,
                                 start_date = "01/02/2007 00:00:00",
                                 end_date = "02/02/2007 23:59:00", 
                                 columns = c("Date","Time","Global_active_power"))
    
    # display histogram on screen
    ylab <- "Global Active Power (killowats)"
    with(data,plot(x = DateTime, y = Global_active_power,
                   type = "l",
                   xlab="", ylab=ylab))
    
    # call copy2png to get the png file at the folders directory
    source("dev.copy2png.R")
    dev.copy2png("plot2.png")
}