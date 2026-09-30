defmodule Distribuido do

  def rodar_consumidor do
    # Registra o processo com o nome :consumidor
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
