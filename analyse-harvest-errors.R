

## read the current harvest errors
current <- read.table('/harvest.csv', sep=',', header=T, comment.char="")

db <- current

## if database with previous errors that are still open
##   does not exist, the current errors will become our database
if (! file.exists('/harvesterrors-db.csv')) {
    db$AGE <- 0
} else {
    ## load database
    db <- read.table('/harvesterrors-db.csv', sep=',', header=T, comment.char="")    
    
    ## loop through current harvest errors and check if an error
    ##   was recorded before. As the criterion, use the field "MELDING".
    ##   If the error was there before, calculate the time since
    ##   when the error is already there, otherwise the time will be zero
    
    for (i in 1:nrow(current)) {
        row <- current[i, ]
        
        ## check if this MELDING exists in the database
        idx <- which(as.character(row$MELDING) == as.character(db$MELDING))

        if (length(idx) > 1) {
            cat("Warning,  duplicate entry in DB\n")
        }
        if (length(idx) > 0) {
            ## calculate difference in dates
            diff <- as.Date(as.character(row$DATUM), format='%Y%m%d') - as.Date(as.character(db$DATUM[idx]), format='%Y%m%d')
            diffdays <- as.character(diff)
            db$AGE[idx] <- diffdays
        }
        else {
            ## add new harvest errors to the database
            cat("Adding new row to database\n")
            row$AGE <- 0
            db <- rbind(row, db)           
        }                
    }
    ## Remove 'resolved' errors from DB, 
    ## i.e. errors that are not in the current harvest errors anymore
    db <- db[as.character(db$MELDING) %in% as.character(current$MELDING),]    
}

## Save database
write.table(db, sep=',', row.names=F, file='/harvesterrors-db.csv', quote=F)


