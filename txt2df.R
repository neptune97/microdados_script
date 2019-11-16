
  ##----------------------------------------------------------------------------
  ## Esta função recebe um vetor de caracteres e divide cada elemento de acordo com os dados de
  ## 'início' e 'fim' do campo
  ##
  ## Argumentos:
  ##
  ## x       : vetor de caracteres contendo as linhas do arquivo de microdados
  ## colunas : vetor com os nomes dos campos
  ## inicio  : vetor numerico contendo o numero da coluna inicial do campo
  ## fim     : vetor numerico contendo o numero da coluna final do campo
  ## dic     : dicionário de dados
  ##----------------------------------------------------------------------------
  # 
  #
  #
  # colocar um indicador de tempo de leitura dos dados....

txt2df <- function(x, dic, colunas){

inicio  <- dic[[ "inicio"]][dic[["cod"]] %in% colunas]
tamanho <- dic[["tamanho"]][dic[["cod"]] %in% colunas]

fim     <- inicio + tamanho - 1

df <- matrix(nr=length(x), nc=length(colunas))                      # dimensiona o data frame (num linhas e colunas)

attributes(df)$dimnames[[2]] <- colunas                             # coloca nomes nas colunas

for(k in seq(length(colunas))){                                     # testar esta estrutura...
    df[, k] <-  substr(x, inicio[k], fim[k])                        # tá funcionando...
}                                                                   # Esta versão tenta imitar um pouco a função le.pesquisa()

df <- apply(df, 2, function(x) gsub("^ +", "", gsub(" +$", "", x))) # remove brancos
df <- as.data.frame(df, stringsAsFactors=FALSE)
df
}

    