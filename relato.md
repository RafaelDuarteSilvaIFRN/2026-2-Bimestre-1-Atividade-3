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

<img width="259" height="126" alt="image" src="https://github.com/user-attachments/assets/c9e4d7c2-dead-4ce5-9469-ef6a4aba5182" />

para criar as imagens foi utilizado:

<img width="344" height="66" alt="image" src="https://github.com/user-attachments/assets/12ad2411-d028-42a7-bf2e-e89dbea3a584" />

para executar os programas:

<img width="319" height="51" alt="image" src="https://github.com/user-attachments/assets/777aa77f-8782-4af7-bdb8-48c8d74a2a21" />

### Comunicação entre tarefas com linhas de execução no mesmo processo

> texto explicando o código

O arquivo sequencial.exs apresenta uma execução sequencial. O programa possui uma função responsável por produzir os dados e outra responsável por consumi-los. A função produzir_dados gera uma lista contendo 100 números aleatórios entre 0 e 110. Em seguida, essa lista é retornada e armazenada pela função principal. Depois, a função consumir_dados recebe essa lista e utiliza Enum.sum para calcular a soma dos valores. Por fim, a função principal controla a ordem de execução, mostrando as mensagens de início e finalização.

> mostrar o código completo

<img width="252" height="379" alt="image" src="https://github.com/user-attachments/assets/cc17f251-7dca-4cfb-8400-5cd604c569ee" />

> explicar como foi executado

O código foi executado utilizando o Docker. O arquivo exemplo_main.exs foi configurado para carregar o arquivo sequencial.exs. Em seguida, a imagem Docker foi criada e o container foi executado utilizando os comandos docker build e docker run.

> mostrar as saídas do terminal

<img width="609" height="53" alt="image" src="https://github.com/user-attachments/assets/cc96c619-1221-4f69-a9c9-15510ce5d2d1" />

> se houve problema na execução, enumerar os problemas e suas respectivas soluções

Durante a execução do código sequencial, não foram encontrados problemas relacionados à lógica do programa. Entretanto, foram encontrados problemas na configuração e execução do Docker. Inicialmente, o caminho utilizado no Dockerfile não correspondia à localização dos arquivos de Elixir, sendo necessário alterar o comando COPY para COPY src/Elixir/ .. Também foi necessário executar o comando docker build no diretório correto, onde se encontra o Dockerfile.

### Comunicação entre tarefas em processos diferentes no mesmo computador

> texto explicando o código

O código paralelo.exs utiliza processos diferentes para realizar as tarefas de produção e consumo dos dados. Um processo é responsável por gerar os números aleatórios, enquanto outro processo recebe esses dados e calcula a soma. Para criar os processos, é utilizada a função spawn. A comunicação entre eles é realizada através das funções send e receive. O processo produtor utiliza send para enviar os dados ao consumidor, enquanto o consumidor utiliza receive para aguardar e receber essa mensagem. Depois de realizar o cálculo, o consumidor envia uma mensagem ao processo principal informando que terminou sua execução. Dessa forma, o processo principal consegue aguardar corretamente a conclusão do consumidor.

> mostrar o código completo

<img width="415" height="823" alt="image" src="https://github.com/user-attachments/assets/0af26d35-ffb1-4baf-aed7-d6d84b964dde" />

> explicar como foi executado

O código foi executado utilizando o Docker. O arquivo exemplo_main.exs foi configurado para carregar o paralelo.exs:

<img width="221" height="74" alt="image" src="https://github.com/user-attachments/assets/8536c2bb-d243-491d-a782-6dc494b9f49d" />

> mostrar as saídas do terminal

<img width="612" height="195" alt="image" src="https://github.com/user-attachments/assets/7cbc23dd-a15f-4d17-8534-355f1fd229a0" />

> se houve problema na execução, enumerar os problemas e suas respectivas soluções

Na primeira versão, foi utilizado Process.sleep para esperar os processos terminarem. Porém, essa não era uma solução ideal, pois o tempo de espera era definido manualmente. Solução: foi utilizado send e receive para criar uma comunicação de término. O consumidor envia :consumidor_terminou para o processo principal quando conclui sua tarefa. Assim, o processo principal aguarda uma confirmação real de que o consumidor terminou.

> Video de teste da execução dos codigo sequencial.exs e paralelo.exs:

https://github.com/user-attachments/assets/b49e0959-0efa-42b8-a39f-03f5f66688d9

https://github.com/user-attachments/assets/ff767202-443a-4256-8748-ecaad630a8ed

### Comunicação entre tarefas em processos diferentes em computadores diferentes

> texto explicando o código

Nesta etapa, será implementada a comunicação entre processos executados em computadores diferentes. Para isso, será utilizado o sistema de distribuição do próprio Elixir, que permite que processos localizados em diferentes máquinas se comuniquem através da rede. Diferentemente da etapa anterior, em que os processos produtor e consumidor estavam no mesmo computador, nesta etapa cada processo será executado em um computador diferente. A comunicação continuará utilizando o conceito de envio e recebimento de mensagens, porém os processos estarão conectados por meio da rede.

> mostrar o código completo
defmodule Distribuido do
  def rodar_consumidor do
    Process.register(self(), :consumidor)
    IO.puts("### Consumidor aguardando mensagem via rede...")

    receive do
      {:dados, dados} ->
        resultado = Enum.sum(dados)
        IO.puts("### Dados recebidos via rede!")
        IO.puts("### Resultado da soma -> #{resultado}")
    end
  end

  def rodar_produtor(no_consumidor) do
    IO.puts("# Produzindo dados no Produtor...")
    dados = for _ <- 1..100, do: :rand.uniform(111) - 1

    send({:consumidor, no_consumidor}, {:dados, dados})
    IO.puts("# Dados enviados para #{inspect(no_consumidor)} com sucesso!")
  end
end

> código Docker para fazer a execução

docker run -it --rm --network host -v $(pwd):/app -w /app elixir_app iex --name consumidor@127.0.0.1 --cookie segredo src/Elixir/distribuido.exs

Distribuido.rodar_consumidor()

docker run -it --rm --network host -v $(pwd):/app -w /app elixir_app iex --name produtor@127.0.0.1 --cookie segredo src/Elixir/distribuido.exs

Distribuido.rodar_produtor(:"consumidor@127.0.0.1")

> explicar como foi executado

A execução da comunicação distribuída foi realizada dentro do ambiente Docker utilizando dois terminais para simular a comunicação através de nós da BEAM (máquina virtual do Elixir):
Início do Nó Consumidor (Terminal 1):
 docker run -it --rm --network host -v $(pwd):/app -w /app elixir_app iex --name consumidor@127.0.0.1 --cookie segredo src/Elixir/distribuido.exs
No console interativo do Elixir (iex), a função de escuta foi ativada:
 Distribuido.rodar_consumidor()
Início do Nó Produtor e Envio de Dados (Terminal 2):
 docker run -it --rm --network host -v $(pwd):/app -w /app elixir_app iex --name produtor@127.0.0.1 --cookie segredo src/Elixir/distribuido.exs
No console interativo do produtor, os dados foram enviados para o nó do consumidor:
 Distribuido.rodar_produtor(:"consumidor@127.0.0.1")

> mostrar as saídas do terminal
Saída no Terminal(Produtor):
 # Produzindo dados no Produtor...
# Dados enviados para :"consumidor@127.0.0.1" com sucesso!
> mostrar as saídas do terminal
Saída do Terminal(Consumidor):
### Consumidor aguardando mensagem via rede...
### Dados recebidos via rede!
### Resultado da soma -> 5851

[Clique aqui para ver o vídeo da execução distribuída](execucao.mp4)
> se houve problema na execução, enumerar os problemas e suas respectivas soluções
Durante a execução da comunicação distribuída, identificou-se que o utilitário do Elixir não estava instalado diretamente no sistema base do ambiente do Codespaces. Esse entrave foi contornado executando os comandos interativos do console do Elixir dentro de containers Docker com a opção de rede do host habilitada. Além disso, o Docker inicialmente não localizou o arquivo da aplicação em seu caminho relativo padrão, o que foi resolvido ao mapear o diretório de trabalho atual diretamente para dentro do container por meio de volumes.
## Considerações finais

FIXME
> conseguiu implementar tudo e executar?
Todas as etapas propostas na atividade foram implementadas e executadas com sucesso no ambiente Docker, cobrindo a execução sequencial, a concorrência no mesmo computador e a comunicação distribuída entre processos em nós distintos da rede.
> qual foi o aprendizado nesse trabalho?
O desenvolvimento do projeto proporcionou um entendimento prático do Modelo de Atores nativo da máquina virtual do Elixir, demonstrando como processos leves trocam mensagens de forma assíncrona sem depender de memória compartilhada ou bibliotecas externas de rede. Também permitiu compreender a importância da sincronização explícita por confirmação de término em substituição a tempos de espera arbitrários, além de evidenciar a facilidade de escalar uma aplicação local para uma arquitetura distribuída utilizando nós nomeados e autenticação por cookie.
> alguma recomendação para próximos alunos?
Recomenda-se atenção constante ao mapeamento de volumes no Docker para garantir a visibilidade dos arquivos entre a máquina hospedeira e o container, bem como a estruturação rigorosa de mensagens de resposta entre os processos para assegurar o fluxo correto de sincronização da execução.
