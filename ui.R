library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("BMI Calculator"),
    
    # Provide inputs for the users to key in their data
    sidebarLayout(position = "left",
        sidebarPanel(
            selectInput("measureSys", "Measurement system", c("Imperial/Standard" = "imp", "Metric" = "met")),
            br(),
            
            radioButtons("gender", "Gender", c("Male" = "male", "Female" = "female")),
            
            numericInput("age", "Age", value = 21, min = 21, max = 80, step = 1),
            
            conditionalPanel(
                condition = "input.measureSys == 'imp'",
                numericInput("heightFeet", "Height (feet)", value = 4, min = 4, max = 7, step = 1),
                numericInput("heightInches", "", value = 0, min = 0, max = 11, step = 1),
                numericInput("weightPounds", "Weight (lbs)", value = 70, min = 70, max = 530, step = 1)
                ),
            
            conditionalPanel(
                condition = "input.measureSys == 'met'",
                numericInput("heightCm", "Height (cm)", value = 120, min = 120, max = 240, step = 1),
                numericInput("weightKg", "Weight (kg)", value = 30, min = 30, max = 200, step = 0.5)
                ),
            
            br(),
            
            actionButton("submitButton", "Calculate")
        ),
        
        # Show a summary of BMI result
        mainPanel(
            h3("Summary of BMI Calculation"),
            h4("BMI"),
            textOutput("bmi_value"),
            br(),
            h4("BMI category"),
            textOutput("bmi_category"),
            br(),
            h4("BMI prime"),
            textOutput("bmi_prime_value"),
            textOutput("bmi_prime_desc"),
            br(),
            h4("Body fat prediction"),
            textOutput("body_fat_pct")
        )
    )
))