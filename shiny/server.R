library(shiny)
library(DT)

format.table <- function(filename) {
    tab <- read.table(filename, header=T, sep=',', comment.char="")

    ## format date column
    tab$DATUM <- as.Date(as.character(tab$DATUM), format='%Y%m%d')

    ## split MELDING column into unitID and melding (if unitID is present)    
    unitIDs <- ifelse(grepl("^[^\\s^\\.]+\\.", tab$MELDING), gsub("\\s.*$", "", tab$MELDING), "")
    tab$UNITID <- unitIDs
    tab
}


## Define server logic required to generate and plot a random distribution
server <- function(input, output, session) {

    
    ## return dataset chosen in dropdown list
    dataSetInput <- reactive({
        base.dir <- "/"
        paste0(base.dir, input$dataset)
    })

    updateSelectInput(session, "dataset", choices=sort(list.files(path="/", pattern="harvest-[0-9]{4}.*\\.csv$")))
    
    ## function for gradient
    colfunc <- colorRampPalette(c("green", "red"))

    ## View 'db' harvest error table with AGE
    output$view.current.table <- DT::renderDataTable({

        ## check if latest harvest file is not older then two days
        timediff = Sys.time() - file.info('/harvest.csv')$mtime < 2880
        
        validate(!is.na(timediff) & timediff,
                 "No harvest data for at least two days! Please contact hannes.hettling@naturalis.nl")

        ## read harvest error database table and format datum
        tab <- format.table('/harvesterrors-db.csv')
        datatable(tab, options=list(pageLength=nrow(tab))) %>% formatStyle( ## dataSetInput()
                               'AGE',
                               backgroundColor = styleEqual(0:max(max(tab$AGE)), colfunc(length(0:max(max(tab$AGE)))))
                               )        
    })
    
    ## View any harvest error table
    output$view.harvest.table <- DT::renderDataTable({        
        ## read harvest error table and format datum
        tab <- format.table(dataSetInput())
        datatable(tab, options=list(pageLength=nrow(tab)))        
    })

    ## Render support link
    output$html.link <- renderUI({
        url <- a("hannes.hettling@naturalis.nl", href=paste("mailto:hannes.hettling@naturalis.nl?Subject=Harvest%20Monitor")) 
        tagList("For bugs, questions and support, please contact", url)
    })
}

