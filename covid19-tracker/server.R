#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(highcharter)
library(tidyr)


source("helper.R")
source("global.R")
tidyToday<- gather(ch_todayn, type, number, `Vaka sayisi`:`Iyilesen sayisi`)
tidyTotal<- gather(ch_totaln, type, number, `Vaka sayisi`:`Iyilesen sayisi`)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    
    wrld <- reactive({
        
        tidyWorld(input$countryName)
    })
    
    wrld1 <- reactive({
        
        tidyWorld(input$countryName1)
    })
    
    
    
    output$worldchart <- renderHighchart({
        
        hchart(wrld(), "line", 
                         hcaes(x = Tarih, y = number, group = type)) %>% 
            hc_title(
                text = ("Covid19 Tum Veriler")) %>%
            hc_tooltip(table = TRUE, sort = TRUE) %>% 
            hc_add_theme(hc_theme_elementary())
    })
    
    output$worldchart1 <- renderHighchart({
        
        hchart(wrld1(), "line", 
               hcaes(x = Tarih, y = number, group = type)) %>% 
            hc_title(
                text = ("Covid19 Tum Veriler")) %>%
            hc_tooltip(table = TRUE, sort = TRUE) %>% 
            hc_add_theme(hc_theme_elementary())
    })
    
    
    output$dailychart <- renderHighchart({
        
        hchart(tidyToday, "line", hcaes(x = date, y = number, group = type)
                                ) %>% 
            hc_title(
            text = ("Covid19 Gunluk Veriler")) %>%
            hc_tooltip(table = TRUE, sort = TRUE) %>% 
            hc_credits(
                enabled = TRUE,
                text = "Kaynak : T.C. Saglik Bakanligi") %>%
            hc_add_theme(hc_theme_elementary())
        
        
    })
    
    output$totalchart <- renderHighchart({
        
        hchart(tidyTotal, "line", hcaes(x = date, y = number, group = type)) %>%
            hc_title(
                text = ("Covid19 Toplam Veriler")) %>%
            hc_tooltip(table = TRUE, sort = TRUE) %>% 
            hc_credits(
                enabled = TRUE,
                text = "Kaynak : T.C. Saglik Bakanligi") %>%
            hc_add_theme(hc_theme_elementary())
    })                   
    
    output$map <- renderHighchart({
        
        hcmap("countries/tr/tr-all", showInLegend = FALSE) %>% 
            hc_add_series(data = mapdata1, type = "mapbubble", name = "Sehirler", maxSize = '20%') %>% 
            hc_mapNavigation(enabled = TRUE) 
    })
    
    output$worldmap <- renderHighchart({
        
        hcmap("custom/world-highres", data = nout, value = "confirmed",
            joinBy = "hc-key", name = "confirmed cases",
            dataLabels = list(enabled = FALSE, format = '{point.name}'),
            borderColor = "blue", borderWidth = 0.1) %>%
            hc_mapNavigation(enabled = TRUE)
    })
    
    # MODAL
    
    observeEvent("", {
        showModal(modalDialog(
            includeHTML("intro.html"),
            easyClose = TRUE,
            footer = tagList(
                actionButton(inputId = "close", label = "Close", icon = icon("info-circle"))
            )
        ))
    })
    
    observeEvent(input$close,{
        removeModal()
    })
})


