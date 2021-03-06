#===============================================================================
# Fun��o para a convers�o do arquivo de microdados para .csv
#  Depende da fun��o 'txt2df'
#
#  Argumentos:
#    input   - arquivo contendo os microdados a serem convertidos para .csv
#    output  - caminho e nome do arquivo convertido 
#    dic     - dicion�rio de dados
#    colunas - nomes das vari�veis a serem inclu�das no arquivo convertido
#    bloco   - quantidade de linhas a serem lidas em cada itera��o. Tamanho default: 50.000 registros
#    ------------------------------------------------------------------------------------------------
#
#    To do:  - se o argumento colunas for deixado em branco, selecionar todas as vari�veis
#            - os dados que s�o caracteres devem ser impressos no arquivo com aspas (quotation) sQuote() or dQuote() functions
#            - implementar a op��o de o arquivo csv gerado tenha ou n�o cabe�alho
#===============================================================================
fwf2csv <- function(input, output, dic, colunas, bloco=50000){ 

con.input  <- file(input,  'r')
con.output <- file(output, 'w')

flag   <- TRUE

writeLines(paste(colunas, collapse=";"), con=con.output) # Escreve os nomes das colunas no arquivo csv   

while(flag){
  linhas <- readLines(con.input, n=bloco)
  dados  <- txt2df(x=linhas, dic=dic, colunas=colunas)  
  writeLines(apply(t(dados), 2, paste, collapse=";"), con=con.output)  
  qtd    <- length(linhas)
  if(qtd < bloco){
     flag <- FALSE
  }
}
close(con.input)
close(con.output)
}



