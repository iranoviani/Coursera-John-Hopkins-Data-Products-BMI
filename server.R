library(shiny)

bmi_value_calc <- function(measureSys, bmi_mass, bmi_height) 
    ifelse(measureSys == "imp", 
           (bmi_mass/(bmi_height ^ 2)) * 703, 
           (bmi_mass/(bmi_height ^ 2)))


bmi_prime_calc <- function(bmi_value)
    bmi_value/25


bmi_prime_pct_calc <- function(bmi_prime_value)
    (bmi_prime_value - 1) * 100


body_fat_pct_calc <- function(bmi_value, age, gender)
    (1.2 * bmi_value) + (0.23 * age) - (10.8 * ifelse(gender == "male", 1, 0)) - 5.4

bmi_category_name = c("Very severely underweight", "Severely underweight", "Underweight", "Normal (healthy weight)", "Overweight", "Obese Class I (Moderately obese)", "Obese Class II (Severely obese)", "Obese Class III (Very severely obese)")

bmi_min_value = c(0, 15, 16, 18.5, 25, 30, 35, 40)

bmi_max_value = c(14.9, 15.9, 18.4, 24.9, 29.9, 34.9, 39.9, 50)

bmi_table <- data.frame(bmi_category_name, bmi_min_value, bmi_max_value)

shinyServer(
    function(input, output) {
        bmi_value <- reactive({as.numeric(
            bmi_value_calc(input$measureSys,
                ifelse(input$measureSys == "imp", input$weightPounds, input$weightKg),
                ifelse(input$measureSys == "imp", (input$heightFeet*12) + input$heightInches, input$heightCm/100)))})
        
        bmi_category <- reactive({
            bmi_table[bmi_table$bmi_min_value <= round(bmi_value(), digits = 1) & 
                          bmi_table$bmi_max_value >= round(bmi_value(), digits = 1), "bmi_category_name"]
        })
        
        bmi_prime_value <- reactive({as.numeric(
            bmi_prime_calc(bmi_value())
            )})
        
        bmi_prime_pct <- reactive({as.numeric(
            bmi_prime_pct_calc(bmi_prime_value())
            )})
        
        body_fat_pct <- reactive({as.numeric(
            body_fat_pct_calc(bmi_value(), input$age, input$gender)
            )})
        
        output$bmi_value <- renderText({
            if (input$submitButton > 0)
                isolate(round(bmi_value(), digits = 1))})
        
        output$bmi_category <- renderText({
            if (input$submitButton > 0)
                isolate(toString(bmi_category()))})
        
        output$bmi_prime_value <- renderText({
            if(input$submitButton > 0)
                isolate(round(bmi_prime_value(), digits = 1))})
        
        output$bmi_prime_desc <- renderText({
            if(input$submitButton > 0)
                isolate(paste("You are ", round(bmi_prime_pct(), digits = 0), "% over the upper mass limit"))})
        
        output$body_fat_pct <- renderText({
            if(input$submitButton > 0)
                isolate(paste(round(body_fat_pct(), digits = 1), "%"))})
})