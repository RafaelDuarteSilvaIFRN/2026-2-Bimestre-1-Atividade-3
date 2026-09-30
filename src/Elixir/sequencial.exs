defmodule Sequencial do

  def produzir_dados do
    dados =
      for _ <- 1..100 do
        :rand.uniform(111) - 1
      end

    dados
  end

  def consumir_dados(dados) do
    resultado = Enum.sum(dados)
    IO.puts("recebeu -> #{resultado}")
  end

  def principal do
    IO.puts("iniciou")

    dados = produzir_dados()
    consumir_dados(dados)

    IO.puts("finalizou")
  end

end