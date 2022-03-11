library(dash)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyverse)


colony <- read.csv("data/colony.csv")
stressor <- read.csv("data/stressor.csv")
state_info <- read.csv("data/state_info.csv")

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
  dbcContainer(
    list(
      htmlH1('Bee Colony Dashboard'),
      dbcRow(
        list(
          dbcCol(
            list(
              htmlLabel('Select Year'),
              dccDropdown(
                id = 'year_widget',
                options = unique(colony$year) %>% purrr::map(function(col) list(label = col, value = col)),
                value = max(colony$year)
              )
            )
          ),
          dbcCol(
            list(
              htmlLabel('Select Month'),
              dccDropdown(
                id = 'month_widget',
                options = unique(colony$months) %>% purrr::map(function(col) list(label = col, value = col)),
                value = min(colony$months)
              )
            )
          ),
          dccGraph(id = 'plot-area')
        )
      )
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('year_widget', 'value'), input('month_widget', 'value')),
  function(int_year, month) {
    df <- colony %>%
      filter(year == int_year, months == month)
    target_df <- left_join(state_info, df, by='state')
    target_df[is.na(target_df)] <- 0
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      lakecolor = toRGB('white')
    )

    plot_ly(target_df) %>%
      layout(geo = g) %>%
      add_trace(type = "choropleth", locationmode = 'USA-states',
                locations = ~abbr,
                z = ~colony_lost_pct,
                color = ~colony_lost_pct, autocolorscale = TRUE) %>%
      add_trace(type = "scattergeo", locationmode = 'USA-states',
                locations = ~abbr, text = ~colony_lost_pct,
                mode = "text",
                textfont = list(color = rgb(0,0,0), size = 12))
  }
)

app$run_server(host = '0.0.0.0')
