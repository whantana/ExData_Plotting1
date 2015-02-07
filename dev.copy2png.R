#
# Copies screen's content to ./figures/content_name
#
dev.copy2png <- function(png_file)
{
    if(!file.exists("./figure"))
        dir.create("./figure")
    png_file <- file.path("./figure",png_file)
    dev.copy(png, file = png_file)
    dev.off()
}