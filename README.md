# Metatrader 5 Robots

Por erlon.dev@gmail.com

## Getting Started

Esse projeto foi desenvolvido para facilitar a criação de robôs traders escritos na linguagem [mql5](https://www.mql5.com/pt)
para a plataforma metatrader 5. Todos os robôs encontram se no diretorio "/Experts", acompanhados de um arquivo .set 
de configuração da estratégia. Inicialmente o projeto foi feito para atender ao mercado de mini contratos futuros da 
bolsa de valores de são paulo (BOVESPA). Para compilar os robôs é necessario acessar o editor de código do metatrader 5.

Cada robô possui sua estratégia, contudo todos possuem funcionalidades basicas em comun, muitas delas já conhecidas 
no mercado de negociação, porém outras nem tanto. Irei retratar todas as funcionalidades que o framework 
de criação de robôs proporciona. Logo abaixo estão as configurações por seções, e em cada seção suas respectivas
variáveis.

![Definições](/Include/Images/definicoes_basicas.JPG)

* Definições Básicas

| Variavel | Descrição |
| ------ | ------ |
|HoraInicio | Hora de inicio de execução da estratégia|
|HoraFim | Hora de término de execução da estratégia|
|HoraInicioIntervalo | Hora de definição de início do intervalo|
|HoraFimIntervalo | Hora de definição de término do intervalo|
|FecharPosition | Defini se irá fechar a posição após estar posicionado em horário fora de execução da estratégia|
|Volume | Defini o volume da sua posição|
|Spread | É o spread utilizado para entrar em uma posição|

* Alvos

| Variavel | Descrição |
| ------ | ------ |
|StopGainEmPontos | Defini em pontos o valor do stop gain da operação|
|StopLossEmPontos | Defini em pontos o valor do stop loss da operação|

* Trailing Stop

| Variavel | Descrição |
| ------ | ------ |
|IsTrailingStop | Ativa ou desativa função de trailing stop|
|TrailingStopInicio | Defini o inicio do trailing stop|
|TrailingStop | Defini o valor aplicado para cada execução do trailing stop|

* Break-Even

| Variavel | Descrição |
| ------ | ------ |
|IsBreakEven | Ativa ou desativa função de break even|
|BreakEvenInicio | Defini o inicio do break even |
|BreakEven | Defini o valor aplicado para cada execução do break even|

* Config de Apresentação

| Variavel | Descrição |
| ------ | ------ |
|IsDesenhar | Ativa ou desativa função de marcação na tela|
|IsPreencher | Habilita preenchimento do desenho |
|IsEnviarParaTras | Envia objeto para fundo do grafico|
|Cor | Defini cor das marcações |
|CorCompra | Defini cor relacionada a compra (Padrão azul)|
|CorVenda|  Defini cor relacionada a venda (Padrão vermelho)|

* Financeiro

| Variavel | Descrição |
| ------ | ------ |
|IsGerenciamentoFinanceiro | Ativa ou desativa função de gerenciameto de risco |
|CorretagemValor | Valor da corretagem da corretora onde esta executando a estratégia |
|IsCalcularCorretagemLucroMaximo | Defini lucro/ prejuizo com corretagem gerada no dia |
|MaximoLucroDiario | Defini lucro máximo do dia|
|MaximoPrejuizoDiario | Defini prejuízo máximo do dia|

* Realização de Parcial

| Variavel | Descrição |
| ------ | ------ |
|IsParcial | Ativa ou desativa função de realização de parcial |
|PrimeiraParcialLotes | Número de lotes para realizar na primeira parcial |
|PrimeiraParcialInicio | Valor em pontos do inicio da parcial |
|SegundaParcialLotes | Número de lotes para realizar na segunda parcial |
|SegundaParcialInicio | Valor em pontos do inicio da parcial |
|TerceiraParcialLotes | Número de lotes para realizar na terceira parcial |
|TerceiraParcialInicio | Valor em pontos do inicio da parcial |

* Expert Control

| Variavel | Descrição |
| ------ | ------ |
|NumeroMagico | Número que é utilizado para identificar o robot |

## Robots

As estratégias abaixo que se encontram em "[/Experts](/Experts)" utilizam o Framework base:

- [Box of consolidation](/Experts/BoxOfConsolidation);
	![box_marcacoes](/Include/Images/box_of_consolidation_marcacoes.JPG)
	![box_compra](/Include/Images/box_of_consolidation_entrada_compra.JPG)
	![box_compra_gain](/Include/Images/box_of_consolidation_entrada_compra_gain.JPG)

- [Line of division](/Experts/TheLineOfDivision);
	![first_candle_marcacoes](/Include/Images/the_line_of_division_marcacoes.JPG)
	![first_candle_marcacoes](/Include/Images/the_line_of_division_marcacao_macro.JPG)
	![first_candle_marcacoes](/Include/Images/the_line_of_division_entrada_venda.JPG)
	![first_candle_marcacoes](/Include/Images/the_line_of_division_entrada_venda_em_andamento.JPG)
	![first_candle_marcacoes](/Include/Images/the_line_of_division_entrada_venda_em_andamento_2.JPG)
	![first_candle_marcacoes](/Include/Images/the_line_of_division_entrada_venda_stop.JPG)

- [First candle](/Experts/FirstCandle);
	![first_candle_marcacoes](/Include/Images/first_candle_marcacoes.JPG)
	![first_candle_marcacoes](/Include/Images/first_candle_entrada_compra.JPG)
	![first_candle_marcacoes](/Include/Images/first_candle_entrada_compra_em_andamento.JPG)
	![first_candle_marcacoes](/Include/Images/first_candle_entrada_compra_gain.JPG)


