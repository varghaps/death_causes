library(ggplot2)

#load data once
if (!exists("death_causes")) load("death_causes.Rda")

shinyServer(
  function(input, output) {
    
    #create reactive dataframe: a subsample with the selected parameters
    df <- reactive({
        subsamp<-(death_causes$age==input$age & death_causes$sex==input$sex & death_causes$region==input$region)
                    
        dframe_sub<-death_causes[subsamp,]    #create data frame 
        dframe_sub[order(-dframe_sub$death_share),] #put in descending order 
    })
    
    #print average number of deaths
    output$text<-renderText({
      
      text_frame<-df()
      
      paste0("Total number of deaths in the selected group in the last 3 years: ", 3*text_frame$n_deaths[text_frame$death_cause_english=="Total (All Causes)"])})
      
    #create ggplot with causes
    output$newHist <- renderPlot({
      
      
      chart_title=paste0("Age: ", input$age, ", sex:", input$sex, ", region: ", input$region)
      plot_frame<-df()
      plot_frame<-plot_frame[plot_frame$death_cause_english!="Total (All Causes)",]
      q<-ggplot(plot_frame, aes(death_cause_english, death_share)) + geom_bar(stat = "identity")
      q<-q+ labs(title=chart_title) + ylab("Share of deaths")+ xlab("Most frequent causes")    
      q<-q+ scale_x_discrete(limits=unique(plot_frame$death_cause_english))+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=13))
      q+coord_fixed(ratio=3)
      #barplot(plot_frame$death_share, main=chart_title, xlab="Most frequent causes", names.arg=plot_frame$death_cause_english, las=2)
    }, height = 400)
    
   
  }
)