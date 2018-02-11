# bad-robot.framework

Imagine um programa de computador que, observando a movimentação dos preços de um ativo ao longo do tempo, é capaz de, sozinho, sem interferência humana, determinar a hora de comprá-lo ou vendê-lo.

## Getting Started

Esse projeto foi desenvolvido para facilitar a criação de robôs traders escritos na linguagem [mql5](https://www.mql5.com/pt)
para a plataforma metatrader 5. Todos os robôs encontram em seus respectivos repositórios, acompanhados de um arquivo .set 
de configuração da estratégia.

* [first-candle](https://github.com/erlonfs/first-candle.bad-robot)
* [box](https://github.com/erlonfs/box.bad-robot)
* [line](https://github.com/erlonfs/line.bad-robot)
* [elephant-walk](https://github.com/erlonfs/elephant-walk.bad-robot)

Para comecar um novo projeto, pode se utilizar o exemplo base:

[mt5-sample-robot](https://github.com/erlonfs/sample.bad-robot)

![sample](https://github.com/erlonfs/sample.bad-robot/blob/master/assets/helloworld/sample.gif)

Inicialmente o projeto foi feito para atender ao mercado de BMF, mais especificamente os mini-contratos 
de índice e dólar. Para compilar os robôs é necessario acessar o editor de código do metatrader 5.

Cada robô possui sua estratégia, contudo todos possuem funcionalidades basicas em comum, muitas delas já conhecidas 
no mercado de negociação.

| Função | Descrição | Possui |
| ------ | ------ | ------ |
|Stop Gain | Saída com lucro em uma operção | SIM |
|Stop Loss | Saída com prejuizo máximo em uma operação | SIM|
|Stop no candle anterior | Determina um novo stop loss a cada novo candlestick, que por sua vez é ajustado para a mínima do mesmo | SIM|
|Horário de inicio e fim | Determina o hórario de início e término do robô | SIM|
|Horário de intervalo | Determina um intervalo para pausa da execução da estratégia |SIM |
|Trailing Stop | Quando ativado, ajusta o stop loss de acordo com o movimento e avanço da preço a favor na operação, ajustando assim o mesmo de acordo com a definição do usuário |SIM|
|Break-even | Habilita o ponto de equilibrio, de acordo com a definição do usuário |SIM|
|Saída Parcial | De acordo com as saídas configuradas, ocorre a realizacao parcial da posição, garantindo parte do lucro caso a operação volte contra a posição |SIM|
|Gerenciamento Financeiro | Habilita o gerenciamento financeiro diário do robô, caso necessite determinar uma parada por atingir um valor de prejuizo máximo diário | SIM|
|Notificações no App MT5 | Envia notificações para o app [metatrader5](https://play.google.com/store/apps/details?id=net.metaquotes.metatrader5&hl=pt_BR) para android (disponivel na play store) |SIM|