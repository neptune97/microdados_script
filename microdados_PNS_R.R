################################################################### ABRINDO MICRODADOS NO R 
################################################################### AUTOR: FERNANDO DE SOUZA 
################################################################### DATA: 14/11/2019  ######

############################################################################################
                               #PARTE 01: OBTENDO O CSV
############################################################################################
## Abra as seguintes funções, elas vão ir juntas com esse arquivo. lembre-se de mudar o 
## diretório do arquivo (caminho) segundo o do seu PC.

source ("~/funcoes/fwf2csv.R")
source ("~/funcoes/txt2df.R")
source ("~/funcoes/getdic.R")

## Depois de carregado as funções você vai passar o input (dicionário de dados) em .txt pro R 
## através desse comando

dicPNS<- getdic("~/pns_2013_microdados_2017_03_23/Dicionarios_e_input/input_PESPNS2013.txt")

## Depois basta criar o CSV a partir deste comando aqui sendo:
## input = o banco de dados, output = nome e caminho aonde o arquivo CSV gerado vai ficar salvo
## dic = dicionário de dados conseguido na função anterior e colunas =  dicionario$cod

fwf2csv(input = "~/pns_2013_microdados_2017_03_23/Dados/PESPNS2013.txt", output = "~/PNSdt.csv", 
        dic = dicPNS, colunas = dicPNS$cod)

######################################################################################################
######################################################################################################
