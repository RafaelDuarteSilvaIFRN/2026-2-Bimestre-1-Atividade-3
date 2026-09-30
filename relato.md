# Relatório sobre implementação de comunicação entre tarefas em Elixir

## Introdução

Este relato faz parte do processo avaliativo da disciplina de sistemas operacionas no curso superior em análise e desenvolvimento de sistemas, ofertado na Diretoria acadêmica de gestão e tecnologia da informação no campus natal-central do instituto federal de educação, ciência e tecnologia do rio grande do norte.

Tem como objetivo principal relatar as implementações de comunicação entre tarefas na linguagem Elixir.

O grupo de trabalho foi formado por Rafael Silva, Fábio Hudson e Daniel Araujo.

## Comunicação entre tarefas em Elixir

### Informações gerais

> qual o objetivo de comunicação entre tarefas? 

A comunicação entre tarefas tem como objetivo permitir que diferentes partes de um programa possam trocar informações e trabalhar em conjunto. Neste trabalho, foi utilizado o Elixir para demonstrar diferentes formas de comunicação, desde a execução sequencial até a comunicação entre processos por meio de mensagens.


> explicar porque usar docker nesse trabalho.

O Docker foi utilizado para criar um ambiente padronizado para executar os códigos em Elixir. Dessa forma, o programa utiliza uma versão específica do Elixir, independentemente da configuração do computador utilizado.

> qual a configuração do docker?

<img width="337" height="190" alt="image" src="https://github.com/user-attachments/assets/b16942d9-600f-44a6-abb9-b2a0d6242eaa" />

para criar as imagens foi utilizado:

<img width="344" height="66" alt="image" src="https://github.com/user-attachments/assets/12ad2411-d028-42a7-bf2e-e89dbea3a584" />

para executar os programas:

<img width="319" height="51" alt="image" src="https://github.com/user-attachments/assets/777aa77f-8782-4af7-bdb8-48c8d74a2a21" />

### Comunicação entre tarefas com linhas de execução no mesmo processo


> texto explicando o código

O arquivo sequencial.exs apresenta uma execução sequencial. O programa possui uma função responsável por produzir os dados e outra responsável por consumi-los. A função produzir_dados gera uma lista contendo 100 números aleatórios entre 0 e 110. Em seguida, essa lista é retornada e armazenada pela função principal. Depois, a função consumir_dados recebe essa lista e utiliza Enum.sum para calcular a soma dos valores. Por fim, a função principal controla a ordem de execução, mostrando as mensagens de início e finalização.

> mostrar o código completo

<img width="282" height="559" alt="image" src="https://github.com/user-attachments/assets/8de6a752-6db3-4ec7-b00a-f6b9d1dff3e4" />

> explicar como foi executado

O código foi executado utilizando o Docker. O arquivo exemplo_main.exs foi configurado para carregar o arquivo sequencial.exs. Em seguida, a imagem Docker foi criada e o container foi executado utilizando os comandos docker build e docker run.

> mostrar as saídas do terminal

<img width="154" height="77" alt="image" src="https://github.com/user-attachments/assets/2f3b7c06-3f48-4754-b248-597bc33efaed" />

> se houve problema na execução, enumerar os problemas e suas respectivas soluções

O processo principal poderia terminar antes dos outros processos Na primeira versão do código paralelo, o processo principal poderia finalizar antes que o produtor e o consumidor terminassem suas atividades. Inicialmente foi utilizado Process.sleep para criar um tempo de espera. Solução: o código foi alterado para utilizar send e receive. O consumidor envia uma mensagem ao processo principal quando termina, permitindo que o processo principal aguarde corretamente a conclusão da tarefa.

### Comunicação entre tarefas em processos diferentes no mesmo computador

FIXME
> texto explicando o código
> mostrar o código completo

FIXME
> explicar como foi executado
> mostrar as saídas do terminal
> mostrar as saídas do terminal

FIXME
> se houve problema na execução, enumerar os problemas e suas respectivas soluções

### Comunicação entre tarefas em processos diferentes em computadores diferentes

FIXME
> texto explicando o código
> mostrar o código completo

FIXME
> explicar como foi executado
> mostrar as saídas do terminal
> mostrar as saídas do terminal

FIXME
> se houve problema na execução, enumerar os problemas e suas respectivas soluções

## Considerações finais

FIXME
> conseguiu implementar tudo e executar?
> qual foi o aprendizado nesse trabalho?
> alguma recomendação para próximos alunos?
