#===============================================================================
#      Função para converter o script SAS em dicionário de variáveis
#      para ser utilizado na função "le.pesquisa()" do pacote IBGEPesq
#      para fazer a leitura dos microdados.
#
#      Autor: Marcos F. Silva
#             http://sites.google.com/site/marcosfs2006
#             marcosfs2006@gmail.com
#
#      Modificado por: Cesar Zucco Jr. (cZ)       
#                      http://fas-polisci.rutgers.edu/zucco/
#
#
#      Versão: 0.0-1 (29.06.2008) - Versão Inicial
#              0.0-2 (25.06.2010) - Esta versão exclui a restrição de que os registros
#                                   tenham que iniciar por branco ou "@".
#              0.0-3 (08.08.2011) - alterado o nome da função de "gerarDic()" para "getdic()"
#              0.0-4 (12.12.2011) - inclusão do input "encoding=latin1"
#              0.0-5 (18.06.2012) - diversas modificações introduzidas por Cezar Zucco 
#              0.0-6 (28.10.2012) - alteracoes introduzidas para lidar com problemas no script de importado dos microdados da POF
#
#       Argumento: inputSAS - arquivo texto contendo o script em SAS para a importação
#                             dos microdados. Os registros contendo a descrição
#                             das variáveis deve possuir a estrutura a seguir:
#
# ------------------------------------------------------------------------------                            
#            Trecho do script PNAD contendo os dados de interesse   
# ------------------------------------------------------------------------------
#            @00001  V0101  $4.    /* ANO DE REFERÊNCIA               */
#            @00005  UF     $2.    /* UNIDADE DA FEDERAÇÃO            */
#            @00005  V0102  $8.    /* NÚMERO DE CONTROLE              */
#
# ------------------------------------------------------------------------------
#            Trecho do script ENEM contendo os dados de interesse
# ------------------------------------------------------------------------------
#            @1		MASC_INSCRITO		$Char8.		/*Mascara do inscrito no ENEM 2007*/
#            @9		NU_ANO				    8.			/*Ano do Enem*/
#            @17	DT_NASCIMENTO	DATETIME20.	/*Data de nascimento do inscrito*/
#            @37	TP_SEXO			    	8.			/*Sexo do inscrito*/
#
#
#===============================================================================
getdic <- function(inputSAS){

  options(warn = -1)
  on.exit(options(warn = 0))

  script <- readLines(inputSAS, encoding="latin1") # ainda falta testar...
  script <- grep("@", script, value = TRUE)        # Pegar qualquer registro onde apareça '@' 
# script <- sub(".*(@.*\\*/).*", "\\1", script)    # (-) Extrair tudo que está entre "@" e "*/"
##  script <- gsub("^\\s*@","",script) 		         # (+) cZ remover espacos iniciais e o @ incial
  script <- gsub("^(\\s|\\w)*@","",script)         # (+) Marcos - 27/10/2012
  script <- gsub(";","",script)						         # (+) cZ remover ; final
  script <- gsub("@","",script,fixed = T)	   		   # (+) cZ remover @ chatos
#  script <- sub("(\\*/) *$", "", script)          # (-) Excluir grupo caractere "*/" do final...
##  script <- sub("(\\s*\\*/) *$", "", script)     # (+) Excluir grupo caractere "*/" do final... [cZ:] e espacos antes do */
  script <- sub("(\\s*\\*/\\t?) *$", "", script)   # (+) Marcos 27/10/2012
  script <- gsub("\\s\\.","\\. ",script) 	         # (+) cZ padrao errado na linha 316 PES2009								
  script <- strsplit(script, "(/\\*)")             # Separar a descrição das variáveis do resto

  # Dividir o registro em duas partes...
  p1 <- lapply(script, function(x) {x <- x[1]})    
  p2 <- lapply(script, function(x) {x <- x[2]})    # Separa as descrições da lista...

  # Tratamento da Primeira Parte (p1)
  p1 <- gsub("\\D*$", "", p1)                      # (+) Marcos 27/10/2012
  p1 <- strsplit(as.character(p1), "[\t ]+")       # Usar tabulação ou espaço como separador. (um ou mais...)
  p1 <- lapply(p1, function(x){x <- x[x!=""]; x})
  p1 <- unlist(p1)

  script <- data.frame(inicio = p1[seq(1, length(p1) - 2, by=3)],
                          cod = p1[seq(2, length(p1) - 1, by=3)],
                      tamanho = p1[seq(3, length(p1)    , by=3)],
                         desc = as.character(p2))

#  script$inicio <- sub("@", "", script$inicio)      # (-)
##  script$inicio  <- as.numeric(script$inicio)		   # (+) cZ convert to number
  script$inicio <-  as.integer(as.character(script$inicio)) # (+) Marcos  27/10/2012
#  script$tamanho <- gsub("(\\$|CHAR|DATETIME)", "", toupper(script$tamanho)) # (-) 
##  script$tamanho <- as.numeric(gsub("(\\$|CHAR|DATETIME|\\.\\d*)", "", toupper(script$tamanho))) 	# (+) cZ added \\.\\d* to get rid of decimalsinteger
  script$tamanho <- as.integer(gsub("(\\$|CHAR|DATETIME|\\.\\d*)", "", toupper(script$tamanho)))   # + Marcos 
  script <- script[, c("inicio", "tamanho", "cod", "desc")] # reordena as colunas
#  script$inicio  <- as.integer(script$inicio)     # (-)
#  script$tamanho <- as.integer(script$tamanho)    # (-) 
  script$cod     <- as.character(script$cod)
  script$desc    <- as.character(script$desc)
  script$desc <- sub("^ +", "", script$desc)       # Remove brancos no início
#  script$desc <- sub(" +$", "", script$desc)      # (-)Remove brancos no final
  script
}


