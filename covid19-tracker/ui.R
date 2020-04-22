#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
Sys.setlocale("LC_ALL", "turkish")

library(shiny.semantic)
library(shinydashboardPlus)
library(shinydashboard)
library(shiny)
library(highcharter)
library(devtools)
library(dashboardthemes)
library(shinycssloaders)

source("helper.R")
source("global.R")


ui<-dashboardPagePlus(
    
    
    title = "Covid19 tracker",
    enable_preloader = TRUE,
    
    dashboardHeaderPlus(
        title = span(img(src = "virus-solid.svg", height = 35), "Covid19 tracker"),
        titleWidth = 300,
        
        dropdownMenu()
    ),
    
    dashboardSidebar(header = singleton(tags$head(includeHTML(("google-analytics.html")))),
                      
                     
                     sidebarMenu(
                         
                         menuItem("Turkiye", tabName = "turkey", icon = icon("flag")),
                         menuItem("Dunya", tabName = "world", icon = icon("globe"), badgeLabel = "Yeni", badgeColor = "green")
                     )
                     ),
    
    dashboardBody(
        
        tags$head(includeCSS('www/fixed_header.css')),
        shinyDashboardThemes(
            theme = "onenote"
        ),
        
        tabItems(
            
            tabItem( tabName = "turkey",
        
                fluidRow(
            
                column(width = 3,
            
                   valueBox(format(total$`Test sayisi`, big.mark = ","), "Toplam test sayısı", icon = icon("vials"), width = NULL),
                   valueBox(format(today$`Test sayisi`, big.mark = ","), "Bugunku test sayısı", icon = icon("vial"), width = NULL),
                   valueBox(paste0("%", format(changetest, digits = 2)), "Test sayısındaki değişim", icon = icon("chart-line"), width = NULL)),
            
                column(width = 3,
                   
                   valueBox(format(total$`Vaka sayisi`, big.mark = ","), "Toplam vaka sayısı", icon = icon("vials"), width = NULL),
                   valueBox(format(today$`Vaka sayisi`, big.mark = ","), "Bugunku vaka sayısı", icon = icon("vial"), width = NULL),
                   valueBox(paste0("%", format(changevaka, digits = 2)), "Vaka sayısındaki değişim", icon = icon("chart-line"), width = NULL)),
            
            box(
                highchartOutput("map") %>% withSpinner(type = 6, color = "purple", size = 0.8)
            ),
            
            
            box(
                    highchartOutput("dailychart") %>% withSpinner(type = 6, color = "purple", size = 0.8)),
            box(
                    highchartOutput("totalchart") %>% withSpinner(type = 6, color = "purple", size = 0.8)
                )
            )
        ),
        
        tabItem( tabName = "world",
                 
                 fluidRow(
                     
                     selectInput(inputId = "countryName", label = "Bir ulke secin", choices = names(out), selected = "Turkey"),
                     
                     box( highchartOutput("worldchart") %>% withSpinner(type = 6, color = "purple", size = 0.8)),
                     box( highchartOutput("worldmap") %>% withSpinner(type = 6, color = "purple", size = 0.8)),
                     selectInput(inputId = "countryName1", label = "Bir ulke secin", choices = names(out), selected = "Italy"),
                     box( highchartOutput("worldchart1") %>% withSpinner(type = 6, color = "purple", size = 0.8)),
                 )
            
            
        )
        
        )
        
    )
    
)
