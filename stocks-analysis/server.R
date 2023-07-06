server <- function(input, output) {
  input_classe <- reactive(input$classe)
  
  input_comp <- eventReactive(input$go, {
      plan_filter <- microsoft_plan[,input$classe_comp]
      plan_filter <- cbind('Date' = microsoft_plan$Date, plan_filter)
      return(plan_filter)
    }
  )
  
  output$daterange <- renderUI({
    min_time <- min(microsoft_plan$Date)
    max_time <- max(microsoft_plan$Date)
    dateRangeInput('daterangeentrada', 'Intervalo: ',
                   start = min_time,
                   end = max_time,
                   min = min_time,
                   max = max_time, startview = 'decade')
  })
  
  output$tabela <- renderDT({
    sub_plan = microsoft_plan[microsoft_plan$Date >= input$daterangeentrada[1] & microsoft_plan$Date <= input$daterangeentrada[2],]
    df <- data.frame(Atributos = c('Nome', 'Média', 'Mediana', 'Desvio padrão', 'Moda','Max', 'Min'),
                     Valores = c(input_classe(), colMeans(sub_plan[input_classe()]), median(sub_plan[, input_classe()]), sd(sub_plan[, input_classe()]), which.max(tabulate(sub_plan[, input_classe()])), max(sub_plan[, input_classe()]), min(sub_plan[, input_classe()])))
    })
  
  output$histograma <- renderPlot({
    sub_plan = microsoft_plan[microsoft_plan$Date >= input$daterangeentrada[1] & microsoft_plan$Date <= input$daterangeentrada[2],]
    ggplot(data = sub_plan, aes(x = sub_plan[, input_classe()])) + geom_histogram( binwidth=7) + ggtitle('Histograma de preços') + xlab('Preços') + ylab('Frequência')
  })
  
   output$boxplot <- renderPlot({
     sub_plan = microsoft_plan[microsoft_plan$Date >= input$daterangeentrada[1] & microsoft_plan$Date <= input$daterangeentrada[2],]
     boxplot(sub_plan[, input_classe()], main = 'Boxplot')
 })
   
   output$grafico_linha <- renderPlot({
     sub_plan = microsoft_plan[microsoft_plan$Date >= input$daterangeentrada[1] & microsoft_plan$Date <= input$daterangeentrada[2],]
     df = data.frame(data = sub_plan$Date, precos = sub_plan[, input_classe()])
     ggplot(df, aes(x = data, y = precos, group = 1)) + geom_line() + ggtitle('Gráfico de Linha')
   }
   )
   
   output$daterange_comp <- renderUI({
     min_time <- min(microsoft_plan$Date)
     max_time <- max(microsoft_plan$Date)
     dateRangeInput('daterangeentrada_comp', 'Intervalo: ',
                    start = min_time,
                    end = max_time,
                    min = min_time,
                    max = max_time, startview = 'decade')
   })
   
   output$tabela_comp <- renderDT({
     sub_plan = input_comp()
     sub_plan = sub_plan[sub_plan$Date >= input$daterangeentrada_comp[1] & sub_plan$Date <= input$daterangeentrada_comp[2],]
     colname <- names(sub_plan)
     df <- data.frame(atributos = c('nome', 'média', 'mediana', 'desvio padrão', 'moda','max', 'min'),
                      classe1 = c(colname[2], colMeans(sub_plan[2]), median(sub_plan[[2]]), sd(sub_plan[[2]]), which.max(tabulate(sub_plan[[2]])), max(sub_plan[[2]]), min(sub_plan[[2]])),
                      classe2 = c(colname[3], colMeans(sub_plan[3]), median(sub_plan[[3]]), sd(sub_plan[[3]]), which.max(tabulate(sub_plan[[3]])), max(sub_plan[[3]]), min(sub_plan[[3]])))
   })
   
   output$grafico_linha_comp <- renderPlot({
     sub_plan = input_comp()
     sub_plan = sub_plan[sub_plan$Date >= input$daterangeentrada_comp[1] & sub_plan$Date <= input$daterangeentrada_comp[2],]
     colname <- names(sub_plan)
     df <- data.frame(datas = sub_plan$Date, classe1 = sub_plan[[2]], classe2 = sub_plan[[3]])
     ggplot() + geom_line(data = df, mapping = aes(x = datas, y = classe1, color = 'blue')) + geom_line(data = df, mapping = aes(x = datas, y = classe2, color = 'green')) + scale_color_manual(values = c('blue' = 'blue', 'green' = 'green'), labels = c(colname[2], colname[3])) + ylab('')
   })
   
   output$bargraph <- renderPlot({
     sub_plan = input_comp()
     sub_plan = sub_plan[sub_plan$Date >= input$daterangeentrada_comp[1] & sub_plan$Date <= input$daterangeentrada_comp[2],]
     colname <- names(sub_plan)
     df = data.frame(nomes_classes = c(colname[2], colname[3]), medias = c(colMeans(sub_plan[2]), colMeans(sub_plan[3])))
     ggplot(df, aes(x = nomes_classes, y = medias)) + geom_col() + scale_y_continuous(n.breaks = 20)
   })
   
   
   output$scatterplot <- renderPlot({
     sub_plan = input_comp()
     sub_plan = sub_plan[sub_plan$Date >= input$daterangeentrada_comp[1] & sub_plan$Date <= input$daterangeentrada_comp[2],]
     colname <- names(sub_plan)
     df <- data.frame(datas = sub_plan$Date, classe1 = sub_plan[[2]], classe2 = sub_plan[[3]])
     ggplot() + geom_point(data = df, mapping = aes(x = classe1, y = classe2)) + scale_y_continuous(n.breaks = 20) + xlab(colname[2]) + ylab(colname[3])
   })
}