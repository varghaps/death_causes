if (!exists("death_causes")) load("death_causes.Rda")
region_list<-sort(unique(death_causes$region))
age_list<-c("0","1-4","5-9", "10-14","15-19","20-24","25-29","30-34","35-39","40-44","45-49", "50-54","55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-")   

shinyUI(pageWithSidebar(
  headerPanel("Causes of death, by region and age in Hungary"),
  sidebarPanel(
    radioButtons("sex", "Sex:",
                 c("Female" = "female",
                   "Male" = "male")),
    selectizeInput(
      'region', 'Region', choices = region_list,
      options = list(
        onInitialize = I('function() { this.setValue("Budapest"); }')
      )
    ),
    selectizeInput(
      'age', 'Age', choices = age_list,
      options = list(
        placeholder = 'Please select an option below',
        onInitialize = I('function() { this.setValue("60-64"); }')
      )
    )
    
    
    ),
  mainPanel(
    h3("Major causes of deaths in selected group",align = "center"),
    plotOutput('newHist'),   #plot chart
    h4(textOutput("text"))   #render text with sum of deaths
    
  )
))