library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  suppressPackageStartupMessages(library(scales))
  options(scipen = 999)
  Confirmed <- read.csv("https://github.com/boyd-chris/Developing-Data-products-Shiny-Project/raw/main/Confirmed.csv")
  Death <- read.csv("https://github.com/boyd-chris/Developing-Data-products-Shiny-Project/raw/main/Death.csv")
  Case_Fatal <- read.csv("https://github.com/boyd-chris/Developing-Data-products-Shiny-Project/raw/main/Case%20Fatality.csv")
  Deathper100 <- read.csv("https://github.com/boyd-chris/Developing-Data-products-Shiny-Project/raw/main/Deathper100K.csv")
  
  Confirmed <- within(Confirmed, rm(X))
  Confirmed[,1] <- paste(substr(Confirmed[,1],1,4), substr(Confirmed[,1],9,11))
  Death <- within(Death, rm(X))
  Death[,1] <- paste(substr(Death[,1],1,4), substr(Death[,1],9,11))
  Case_Fatal <- within(Case_Fatal, rm(X))
  Case_Fatal[,1] <- paste(substr(Case_Fatal[,1],1,4), substr(Case_Fatal[,1],9,11))
  Deathper100 <- within(Deathper100, rm(X))
  Deathper100[,1] <- paste(substr(Deathper100[,1],1,4), substr(Deathper100[,1],9,11))
  Case_Fatal_Orig <- Case_Fatal
  for (i in 2:ncol(Case_Fatal)) {
    Case_Fatal[,i] <- as.numeric(sub("%", "", Case_Fatal[,i]))
  }
 
  SelPt <- reactive({
    CountrySel <- input$country
    SelType <- sub(" ", "_", input$ChoiceType)
    if (SelType == "Confirmed Cases") {
      DFSel <- Confirmed}  else if (SelType == "Death") {
        DFSel <- Death} else if (SelType == "Case Fatality") {
          DFSel <- Case_Fatal} else {DFSel <- Deathper100}  })
  output$country <- renderText(input$country)
  output$ChoiceType <- renderText(input$ChoiceType)
  output$plot1 <- renderPlot({
    CountrySel <- sub(" ", "_",input$country)
    SelType <- input$ChoiceType
    if (SelType == "Confirmed Cases") {
      DFSel <- Confirmed}  else if (SelType == "Death") {
        DFSel <- Death} else if (SelType == "Case Fatality") {
          DFSel <- Case_Fatal} else {DFSel <- Deathper100}    
    par(las = 2)
    par(mar = c(7,6,1,1))
    plot(DFSel[,names(DFSel) == CountrySel], type = "l", xlab = "", ylab = "" , las = 2, lwd = 2, col = "blue", xaxt = "n")
    abline(lsfit(1:nrow(DFSel), DFSel[,names(DFSel) == CountrySel]), col = "green", lwd = 2)
    axis(1, at = 1:nrow(Confirmed), labels = Confirmed[,1])
    mtext(text = "Month & Year", side = 1, line = 5, las = 1)
    mtext(text = "Monthly Average", side = 2, line = 5, las = 0)
    legend("top", legend = c("Actual", "Trend"), col = c("blue", "green"), lwd = 2)
  })
  output$DispTable <- renderDataTable({
    CountrySel <- sub(" ", "_",input$country)
    data.frame("Month Year" = Confirmed[,1],
               "Confirmed Cases" = Confirmed[,names(Confirmed) == CountrySel],
               "Death" = Death[,names(Death) == CountrySel],
               "Case Fatality" = Case_Fatal_Orig[,names(Case_Fatal_Orig) == CountrySel],
                "Death per 100,000" = Deathper100[,names(Deathper100) == CountrySel])
#    names(Table1) = c("Month & Year", "Confirmed Cases", "Death", "Case Fatality", "Death per 100,000")
  })
})


