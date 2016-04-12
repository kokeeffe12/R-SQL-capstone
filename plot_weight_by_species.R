# extracts species and weights for a given year from portal rodent 
# database; makes a fancy plot and saves the plot to a file

library(RSQLite)
library(ggplot2)

# get command-line arguments
args <- commandArgs(TRUE)
if (length(args)==0) {
  stop("Script requires a year argument", call.=FALSE)
} else if (length(args)==1) {
  year <- args[1]
}

year=1990

print(paste("Getting data for year",year))

# create a connection to the database
# 
myDB <- "~/Desktop/Portal_mammals.sqlite"
conn <- dbConnect(drv = SQLite(), dbname= myDB)

# some database functions for listing tables and fields
dbListTables(conn)
dbListFields(conn,"surveys")

# constructing a query
query_string <- "SELECT count(*) FROM surveys"
result<-dbGetQuery(conn,query_string)
head(result)

# write a query that gets the non-null weights for 
# all species in this year
query_string <- paste("SELECT species_id,weight FROM surveys WHERE weight IS NOT NULL AND year=",year)
result <- dbGetQuery(conn,query_string)
head(result)

# plot the data and save to a png file
ggplot(data = result, aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, color = 'tomato') +
  geom_boxplot(alpha = 0)
outputfilename <- paste(year,"SWC.png")
ggsave(outputfilename)
