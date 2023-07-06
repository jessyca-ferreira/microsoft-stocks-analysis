ui <- dashboardPage(
  dashboardHeader(title = '', titleWidth = 0),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Análise Individual', tabName = 'individual', icon = icon('chart-line')),
      menuItem('Comparações', tabName = 'comp', icon = icon('chart-bar'))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = 'individual',
              h1('Projeto de Estatística'),
              h5('Por: Jéssyca Ferreira da Silva, João Antonio de Lima Reis, Luis Guilherme Nunes'),
              br(),
              h5('Análises e comparações realizadas sobre as ações da Microsoft'),
              fluidRow(
                  box(status = 'danger', with = 12,
                    selectInput('classe', 'Classes', choices = c('Open' = nomes[2], 'High' = nomes[3], 'Low' = nomes[4], 'Close' = nomes[5])),
                    uiOutput('daterange')
                  )
              ),
              fluidRow(
                box(title = 'Tabela', solidHeader = TRUE, status = 'danger', width = 12,
                    DTOutput('tabela')
                )
              ),
              fluidRow(
                box(title = 'Informações', solideHeader = TRUE, status = 'danger', width = 12,
                  plotOutput('grafico_linha'),
                  plotOutput('histograma'),
                  plotOutput('boxplot')
                )
              )
      ),
      
      tabItem(tabName = 'comp',
              h1('Projeto de Estatística'),
              h5('Grupo: Jéssyca Ferreira da Silva, João Antonio de Lima Reis, Luis Guilherme Nunes'),
              br(),
              h5('Análises e comparações realizadas sobre as ações da Microsoft'),
  
              fluidRow(        
                box(status = 'danger', width = 12,
                  selectizeInput('classe_comp', 'Classes', choices = c('Open' = nomes[2], 'High' = nomes[3], 'Low' = nomes[4], 'Close' = nomes[5]), multiple = TRUE, options = list(maxItems = 2)),
                  actionButton('go', 'Ok'),
                  uiOutput('daterange_comp'),
                )
              ),
              fluidRow(
                box(title = 'Tabela', solidHeader = TRUE, status = 'danger', width = 12,
                  DTOutput('tabela_comp')
                )
              ),
              
              fluidRow(
                box(title = 'Informações', solideHeader = TRUE, status = 'danger', width = 12,
                  plotOutput('grafico_linha_comp'),
                  plotOutput('bargraph'),
                  plotOutput('scatterplot'))
                )
              )
    )
  ),
  
  skin = 'red'
)
