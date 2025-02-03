library(bslib)
library(markdown)

# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
vars <- setdiff(names(iris), "Species")
spec_opts <- c("A. armata", "A. taxiformis", "Ulva", "Ecklonia")
stat_opts <- c("Tasmania", "South Australia")

library(markdown)

navbarPage(
  
  # Navbar title
  "Grow!",
  
  # Species -------------------------------------------------------------------------------------------------------
  tabPanel(
    "Species",
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "species", label = "Select a species", choices = spec_opts)
        # radioButtons("species", "Species", c("A. armata"="aa", "A. taxiformis"="at"))
        ),
      mainPanel(imageOutput("pic1"))
      )
    ),

  # Temperature ---------------------------------------------------------------------------------------------------
  tabPanel(
    "Temperature",
    sidebarLayout(
      sidebarPanel(
        tags$h4("Temperature affects how the macroalgae grows. Select a state average temperature curve or create your own."),
        selectInput(inputId = "temp_state", label = "State", choices = stat_opts),
        sliderInput("mean_temp", "Mean temperature (C)", min = 5, max = 35, value = 20, step = 1),
        sliderInput("peak_temp", "Day of the year when temperature is at maximum", min = 0, max = 365, value = 60, step = 14),
        sliderInput("var_temp", "Maximum variation from the mean (C)", min = 0, max = 20, value = 5, step = 1),
      ),
      mainPanel(
        tags$h2("Annual temperature"),
        plotOutput("temp_plot"),
        tags$small("Possibility of adding an 'upload' button here so that someone can upload their own data and it will appear as points on the above plot.")
        )
      )
    ),

  # Nutrient dropdown ---------------------------------------------------------------------------------------------
  navbarMenu(
    "Nutrients",
    tabPanel(
      "Nitrate",
      sidebarLayout(
        sidebarPanel(
          tags$h4("Macroalgae won't grow without nutrients. Select a state average nutrient curve or create your own."),
          selectInput(inputId = "nitr_state", label = "State", choices = stat_opts),
          sliderInput("mean_nitr", "Mean nitrate concentration (uM)", min = 2, max = 16, value = 5, step = 1),
          sliderInput("peak_nitr", "Day of the year when nitrate is at maximum", min = 0, max = 365, value = 60, step = 14),
          sliderInput("var_nitr", "Maximum variation from the mean (uM)", min = 0, max = 20, value = 5, step = 1),
        ),
        mainPanel(
          tags$h2("Annual nitrerature"),
          plotOutput("nitr_plot"),
          tags$small("Possibility of adding an 'upload' button here so that someone can upload their own data and it will appear as points on the above plot.")
        )
      )
    ),
    tabPanel(
      "Ammonium",
      sidebarLayout(
        sidebarPanel(
          tags$h4("Macroalgae won't grow without nutrients. Select a state average nutrient curve or create your own."),
          selectInput(inputId = "ammo_state", label = "State", choices = stat_opts),
          sliderInput("mean_ammo", "Mean ammonium concentration (uM)", min = 2, max = 16, value = 5, step = 1),
          sliderInput("peak_ammo", "Day of the year when ammonium is at maximum", min = 0, max = 365, value = 60, step = 14),
          sliderInput("var_ammo", "Maximum variation from the mean (uM)", min = 0, max = 20, value = 5, step = 1),
        ),
        mainPanel(
          tags$h2("Annual ammonium concentration"),
          plotOutput("ammo_plot"),
          tags$small("Possibility of adding an 'upload' button here so that someone can upload their own data and it will appear as points on the above plot.")
        )
      )
    ),
    tabPanel(
      "Extra",
      sidebarLayout(
        sidebarPanel(
          tags$h4("Macroalgae won't grow without nutrients. Select a state average nutrient curve or create your own."),
          selectInput(inputId = "extraN_state", label = "State", choices = stat_opts),
          sliderInput("mean_extraN", "Mean nitrate concentration (uM)", min = 2, max = 16, value = 5, step = 1),
          sliderInput("peak_extraN", "Day of the year when nitrate is at maximum", min = 0, max = 365, value = 60, step = 14),
          sliderInput("var_extraN", "Maximum variation from the mean (uM)", min = 0, max = 20, value = 5, step = 1),
        ),
        mainPanel(
          tags$h2("Annual extra"),
          plotOutput("extraN_plot"),
          tags$small("Possibility of adding an 'upload' button here so that someone can upload their own data and it will appear as points on the above plot.")
        )
      )
    ),
  ),
  
  # Light ---------------------------------------------------------------------------------------------------------
  tabPanel(
    "Temperature",
    sidebarLayout(
      sidebarPanel(
        tags$h4("Temperature affects how the macroalgae grows. Select a state average temperature curve or create your own."),
        selectInput(inputId = "temp_state", label = "State", choices = stat_opts),
        sliderInput("mean_temp", "Mean temperature (C)", min = 5, max = 35, value = 20, step = 1),
        sliderInput("peak_temp", "Day of the year when temperature is at maximum", min = 0, max = 365, value = 60, step = 14),
        sliderInput("var_temp", "Maximum variation from the mean (C)", min = 0, max = 20, value = 5, step = 1),
      ),
      mainPanel(
        tags$h2("Annual temperature"),
        plotOutput("temp_plot"),
        tags$small("Possibility of adding an 'upload' button here so that someone can upload their own data and it will appear as points on the above plot.")
        )
      )
    ),
  
  # More ----------------------------------------------------------------------------------------------------------
  navbarMenu(
    "More",
    tabPanel(
      "Table",
      DT::dataTableOutput("table")
      ),
    tabPanel(
      "About",
      fluidRow(
        column(6, includeMarkdown("about.md")),
        column(3, img(class="img-polaroid", src=paste0("http://upload.wikimedia.org/", "wikipedia/commons/9/92/", "1919_Ford_Model_T_Highboy_Coupe.jpg")),
               tags$small("Source: Photographed at the Bay State Antique ", "Automobile Club's July 10, 2005 show at the ",
                          "Endicott Estate in Dedham, MA by ", a(href="http://commons.wikimedia.org/wiki/User:Sfoskett", "User:Sfoskett"))
               )
        )
      )
    )
  )
