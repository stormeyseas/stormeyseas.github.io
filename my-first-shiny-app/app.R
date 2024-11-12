library(shiny)
library(shinyWidgets)

df <- data.frame(
  val = c("Factory","Shop", "Park", "Tavern", "Office", "Civic", "House")
)

df$img = c(
  sprintf("<img src='images/factory/factory-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[1]),
  sprintf("<img src='images/shop/shop-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[2]),
  sprintf("<img src='images/park/park-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[3]),
  sprintf("<img src='images/tavern/tavern-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[4]),
  sprintf("<img src='images/civic/civic-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[5]),
  sprintf("<img src='images/house/house-80-80.jpg' width=30px><div class='jhr'>%s</div></img>", df$val[6])
)

civics$type <- c(
  "Sports field", "Elementary School"
)

civics$type <- c(
  sprintf("<img src='images/civics/sports.jpg' width=30px><div class='jhr'>%s</div></img>", civics$type[1]),
  sprintf("<img src='images/civics/elementary.jpg' width=30px><div class='jhr'>%s</div></img>", civics$type[2]),
)

ui <- fluidPage(
  tags$head(tags$style(
  ".jhr{
    display: inline;
    vertical-align: middle;
    padding-left: 10px;
  }"
  )),
  
  pickerInput(inputId = "Id0109",
              label = "pickerInput Palettes",
              choices = df$val,
              choicesOpt = list(content = df$img))

)

server <- function(input, output) {}
shinyApp(ui, server)
