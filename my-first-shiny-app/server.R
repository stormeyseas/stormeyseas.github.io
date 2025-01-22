library(shiny)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
library(magrittr)

# devtools::install_github("stormeyseas/macrogrow")
library(macrogrow)

# Default data ----------------------------------------------------------------------------------------------------
spec_data <- tibble::tribble(
  ~species, ~code, ~x, ~y, ~img,
  "A. armata", "aa", 1, 5, "images/Asparagopsis.jpg",
  "A. taxiformis", "at", 2, 2, "images/Asparagopsis.jpg",
  "Ulva", "ul", 3, 6, "images/Asparagopsis.jpg",
  "Ecklonia", "ec", 4, 3, "images/Asparagopsis.jpg"
) %>% 
  mutate(species = as.factor(species))

env_data <- tibble::tribble(
  ~state,            ~mean_temp,  ~peak_temp,  ~var_temp,
  "Tasmania",        15,          35,          10,
  "South Australia", 20,          40,          12
)

function(input, output, session) {
  # Species panel -------------------------------------------------------------------------------------------------
  ## Get input ----------------------------------------------------------------------------------------------------
  selectedData <- reactive({
    # observe({
    #   x = input$species
    #   
    #   if(x=='A'){
    #     updateSelectInput(session,'d2',
    #                       choices = sort(unique(df$col2)),
    #                       selected = 'LOW')
    #   }else if(x=='C' || x=='D'){
    #     updateSelectInput(session,'d2',
    #                       choices = sort(unique(df$col2)),
    #                       selected = 'HIGH')
    #   }else{
    #     updateSelectInput(session,'d2',
    #                       choices = sort(unique(df$col2)),
    #                       selected = 'MEDIUM')
    #   }
    #   
    # })
    
    spec_data[spec_data$species == input$species, ]
  })
  
  ## Render output ------------------------------------------------------------------------------------------------
  output$pic1 <- renderImage({
    if (input$species == spec_data$species[1]) {list(src = "resources/images/Asparagopsis.jpg", height = "75%")} else
    if (input$species == spec_data$species[2]) {list(src = "resources/images/Asparagopsis.jpg", height = "75%")} else
    if (input$species == spec_data$species[3]) {list(src = "resources/images/Asparagopsis.jpg", height = "75%")} else
    if (input$species == spec_data$species[4]) {list(src = "resources/images/Asparagopsis.jpg", height = "75%")},
      deleteFile = FALSE
  })
  
  uiOutput({
    img(height = 240, width = 300, src = selectedData()$img)
  })
  
  # Temperature panel ---------------------------------------------------------------------------------------------
  ## Get input ----------------------------------------------------------------------------------------------------
  temp_state_selected <- reactive({
    data.frame(mean_temp0 = env_data$mean_temp[env_data$state == input$temp_state], 
               peak_temp0 = env_data$peak_temp[env_data$state == input$temp_state], 
               var_temp0 = env_data$var_temp[env_data$state == input$temp_state])
  })
  temp_selected <- reactive({
    data.frame(mean_temp = input$mean_temp, peak_temp = input$peak_temp, var_temp = input$var_temp)
  })
  
  ## Render output ------------------------------------------------------------------------------------------------
  output$temp_plot <- renderPlot({
    temp_data <- data.frame(doy = 1:365)
    temp_data$temp <- temp_selected()$mean_temp + temp_selected()$var_temp * sin((2*pi*(temp_data$doy-temp_selected()$peak_temp+90)/365))
    ggplot() +
      geom_line(data = temp_data, aes(x = doy, y = temp)) +
      theme_classic() +
      scale_x_continuous(breaks = seq(0,365, 90)) +
      scale_y_continuous(breaks = seq(temp_selected()$mean_temp-temp_selected()$var_temp,
                                      temp_selected()$mean_temp+temp_selected()$var_temp,
                                      length.out = 5)) +
      theme(text = element_text(family = "sans", size = 14, colour = "black")) +
      labs(x = "Day of the year", y = "Temperature")
  })

  # Nutrient panels -----------------------------------------------------------------------------------------------
  ## Get input ----------------------------------------------------------------------------------------------------
  nitr_state_selected <- reactive({
    data.frame(mean_nitr0 = env_data$mean_nitr[env_data$state == input$nitr_state], 
               peak_nitr0 = env_data$peak_nitr[env_data$state == input$nitr_state], 
               var_nitr0 = env_data$var_nitr[env_data$state == input$nitr_state])
  })
  nitr_selected <- reactive({
    data.frame(mean_nitr = input$mean_nitr, peak_nitr = input$peak_nitr, var_nitr = input$var_nitr)
  })
  
  ## Render output ------------------------------------------------------------------------------------------------
  output$nitr_plot <- renderPlot({
    nitr_data <- data.frame(doy = 1:365)
    nitr_data$nitr <- nitr_selected()$mean_nitr + nitr_selected()$var_nitr * sin((2*pi*(nitr_data$doy-nitr_selected()$peak_nitr+90)/365))
    ggplot() +
      geom_line(data = nitr_data, aes(x = doy, y = nitr)) +
      theme_classic() +
      scale_x_continuous(breaks = seq(0,365, 90)) +
      scale_y_continuous(breaks = seq(nitr_selected()$mean_nitr-nitr_selected()$var_nitr,
                                      nitr_selected()$mean_nitr+nitr_selected()$var_nitr,
                                      length.out = 5)) +
      theme(text = element_text(family = "sans", size = 14, colour = "black")) +
      labs(x = "Day of the year", y = "Nitrate concentration")
  })
  
}
