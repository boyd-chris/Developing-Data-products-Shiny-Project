library(shiny)
shinyUI(fluidPage(
  headerPanel(
    h1("Covid Cases (monthly) - Top 10 Countries", align = "center")
    ),
  sidebarLayout(
     sidebarPanel(
       helpText("Select a country from the list below", br(),
                "Select the type of plot required", br(),
                "Then press the button 'Confirm'", br(),
                " "),
       selectInput("country", "Select a Country", c("Brazil", "France", "Germany", "India", "Italy", "Russia", "Spain", "Turkey", "United Kingdom", "United States")),
       radioButtons("ChoiceType", "Select the Type of Report", c("Confirmed Cases", "Deaths", "Case Fatality", "Death per 100,000")),
       submitButton("Confirm")
     ),
        # Show a plot of the generated distribution
        mainPanel(
            h2(textOutput("country"), align = "center"),
            h3(textOutput("ChoiceType"), align = "center"),
            plotOutput("plot1"),
            h3("Data used in this Plot", align = "center"),
            h6("Data Source: https://coronavirus.jhu.edu/map.html", align = "center"),
            dataTableOutput("DispTable")
        )
    )
))
