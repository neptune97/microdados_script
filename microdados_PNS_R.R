################################################################### ABRINDO MICRODADOS NO R 
################################################################### AUTOR: FERNANDO DE SOUZA 
################################################################### DATA: 14/11/2019  ######

############################################################################################
                               #TÉCNICA 01: FUNÇÃO read.fwf
############################################################################################
## A função base para manejo de microdados no R é a read.fwf. basta que você tenha em mãos 
## o tamanho (ou width) das variáveis que deseja extrair do banco
## a função deve conter o caminho do banco de dados ("~/bd"), os widths e se os dados vêm ou
## não com cabeçalho (header).
read.fwf ("~/bd", widths = c(), header = "")


############################################################################################
                               #TÉCNICA 02: OBTENDO O CSV
############################################################################################
## No entanto, algumas vezes não queremos trabalhar os dados no próprio R, ou a conversão com 
## o read.fwf demora bastante, logo transformar os dados em CSV e daí fazer as análises se 
## torna mais interessante: segue abaixo como fazer isso:
##
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
                                  # TÉCNICA 03: FUNÇÃO read.SAScii
######################################################################################################

## Os microdados nacionais tem a característica de serem acompanhados de dicionário de variáveis em 
## formato SAS. Nesses casos é possível fazer com que o R, a partir do dicionário, retire os pesos das
## variáveis e consiga ler o microdado com mais rapidez e facilidade. para isso usaremos o package
## (SAScii).
##
## Primeiro instale o package e o abra

install.packages ("SAScii")
library (Sascii)

## O segundo passo é dizer ao R aonde está o dicionário de dados,do qual ele irá extrair o peso das vari-
## áveis, isso é possível através da função (parse.SAScii). O único argumento necessário é o caminho do
## dicionário de variáveis

parse.SAScii ("~/Dicionarios_e_input/input_PESPNS2013.sas")

## O terceiro passo é abrir o microdado. Para isso usaremos a função (read.SAScii). que tem como argumentos
## o caminho do dicionário (ou input), o caminho do banco de dados, a linha de onde ele deve começar a ler 
##os dados e um último que dá um boost na leitura.

bd<- read.SAScii("~/pns_2013_microdados_2017_03_23/Dicionarios_e_input/input_PESPNS2013.sas","~/pns_2013_microdados_2017_03_23/Dados/PESPNS2013.txt", 
                 beginline = 3, buffersize = 1000)
