#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
Sys.setlocale("LC_ALL", "turkish")

library(shinydashboardPlus)
library(shinydashboard)
library(shiny)
library(highcharter)

source("helper.R")
source("global.R")


ui<-dashboardPagePlus(
    
    title = "Covid19 tracker",
    skin = "black",
    
    
    dashboardHeader(
        title = span(img(src = "virus-solid.svg", height = 35), "Covid19 tracker"),
        titleWidth = 300,
        
        dropdownMenu()
    ),
    
    dashboardSidebar(header = singleton(tags$head(includeHTML(("google-analytics.html")))),
                     
                     sidebarMenu(
                         
                         menuItem("Turkiye", tabName = "turkey" ),
                         menuItem("Dunya", tabName = "world", icon = icon("world"), badgeLabel = "Yeni", badgeColor = "green")
                     )
                     ),
    
    dashboardBody(
        
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
                highchartOutput("map")
            ),
            
            
            box(
                    highchartOutput("dailychart")),
            box(
                    highchartOutput("totalchart")
                )
            )
        ),
        
        tabItem( tabName = "world",
                 
                 fluidRow(
                     
                     selectInput(inputId = "countryName", label = "Bir ulke secin", choices = names(out), selected = "Turkey"),
                     
                     box( highchartOutput("worldchart"))
                 )
            
            
        )
        
        )
        
    )
    
)
