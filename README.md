# BadRobot Framework

![Package version](https://img.shields.io/github/release/erlonfs/bad-robot.framework.svg?style=flat-square)
[![Open Source Love png2](https://badges.frapsoft.com/os/v2/open-source.png?v=103)](https://github.com/erlonfs/bad-robot.framework/)
[![GitHub license](https://img.shields.io/github/license/erlonfs/bad-robot.framework.svg)](https://github.com/erlonfs/bad-robot.framework/blob/master/LICENSE)
[![Join the chat at Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/bad-robot-framework/)

![GitHub stars](https://img.shields.io/github/stars/erlonfs/bad-robot.framework.svg?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/erlonfs/bad-robot.framework.svg?style=social)
![GitHub issues](https://img.shields.io/github/issues/erlonfs/bad-robot.framework.svg?style=social)
![GitHub pulls](https://img.shields.io/github/issues-pr/erlonfs/bad-robot.framework.svg?style=social)
![GitHub forks](https://img.shields.io/github/forks/erlonfs/bad-robot.framework.svg?style=social)

Um framework de criação de robôs traders, onde todas as [definições e gerenciamentos](#features) ficam por conta do BadRobot. Implemente apenas a estratégia sem se preocupar com o gerenciamento do trade.

## Getting Started

Faça o [download](https://github.com/erlonfs/bad-robot.framework/archive/master.zip) do framework ou `git clone https://github.com/erlonfs/bad-robot.framework.git`. 
Copie ou clone o projeto dentro do diretorio de instalação do [metatrader 5](https://www.metatrader5.com/pt), na pasta MQL5.

### Prerequisites

Ferramentas necessárias para desenvolvimento

```
Metatrader 5
MetaEditor 5
```

### Installing

Execute o [metatrader 5](https://www.metatrader5.com/pt), acesse o editor de linguagem MetaQuotes (MetaEditor 5) ou pressione `f4` no terminal de negociação. Acesse o menu `Arquivo > Abrir diretório de dados`. Você está dentro do diretório da instalação do terminal, acesse a pasta `\MQL5`. Todo o codigo do framework deve ser baixado ou clonado aqui.

```
$ cd MQL5
$ git clone https://github.com/erlonfs/bad-robot.framework.git
```

Até o momento temos o framework no diretório de desenvolvimento. O Proximo passo é repetir o procedimento para os robôs especificamente. O diretório onde eles deverão ser clonados será `\Experts`.

Exemplo
```
$ cd Experts
$ git clone https://github.com/erlonfs/first-candle.bad-robot.git
```

Apos isso, retorne ao editor de codigos, utilizado o navegador à esqueda para explorar o diretório de desenvolvimento, acesse a pasta `\Experts\first-candle.bad-robot`, e o arquivo `first_candle.mq5`. Compile o projeto ou pressione ``` F7 ```. 

Dessa forma estará sendo compilado o robô na versão de instalação do framework. Para versões mais atualizadas do BadRobot acesse  https://github.com/erlonfs/bad-robot.framework/releases. Repita o procedimento para novas atualizaçôes do framework, necessitando apenas de uma nova compilação do robô.

### Features

Funções e ferramentas que o framework oferece:

| Função | Descrição |
| ------ | ------ |
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

Para comecar um novo projeto, pode se utilizar o exemplo [sample.bad-robot](https://github.com/erlonfs/sample.bad-robot). Pois ele já possui uma estrutura com uso do framework, faltando apenas a codificação da estratégia.

## Running the tests

Por limitações da linguagem [mql5](https://www.mql5.com/pt), ainda não possui testes unitários implementados no framework. Utiliza backtest do metatrader5 e técnicas de debugging.

## Deployment

Ao compilar o robô, um arquivo com mesmo nome `first_candle.mq5`, mas com extensão `.ex5` estará no diretório do mesmo. Ficando assim:
```
first_candle.ex5
```

Esse será o executável do robô. De volta ao [metatrader 5](https://www.metatrader5.com/pt), no navegador `Exibir\Navegador` (```CTRL+N ```), no grupo `Consultor expert` estará o robô, pronto para uso.

## Contributing

Entre em contato pra discutirmos novas idéias e então é so submeter um pull request.

## Versioning

Nós utilizamos  [SemVer](http://semver.org/) para versionamento. Para versões disponiveis, acesse [tags on this repository](https://github.com/erlonfs/bad-robot.framework/tags). 

## Authors

* **Erlon F Souza** - *Idealizador* - [erlonfs](https://github.com/erlonfs)

Veja também a lista de  [contribuidores](https://github.com/erlonfs/bad-robot.framework/graphs/contributors) Participantes do projeto.

## License

Este projeto é licenciado sob a MIT License - veja em [LICENSE](LICENSE) para mais detalhes

## See more

Veja outros robôs desenvolvidos utlizando o framework

* https://github.com/erlonfs/first-candle.bad-robot
* https://github.com/erlonfs/box.bad-robot
* https://github.com/erlonfs/elephant-walk.bad-robot
* https://github.com/erlonfs/line.bad-robot

Quer utilizar o robô e não sabe como obter o executável apenas com o código-fonte? Entre em contato através do email erlon.efs@gmail.com para fornece-lo. E bons trades!

