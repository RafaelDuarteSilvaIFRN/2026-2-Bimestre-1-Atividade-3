defmodule Paralelo do

  def produzir_dados do
    IO.puts("# produzir - iniciado")

    dados =
      for _ <- 1..100 do
        :rand.uniform(111) - 1
      end

    IO.inspect(dados, label: "# produzir")

    IO.puts("# produzir - terminado")

    dados
  end

  def consumir_dados do
    IO.puts("### consumir - iniciado")

    receive do
      {:dados, dados, principal} ->
        IO.inspect(dados, label: "### dados")

        resultado = Enum.sum(dados)

        IO.puts("### resultado -> #{resultado}")
        IO.puts("### consumir - terminado")

        send(principal, :consumidor_terminou)
    end
  end

  def principal do
    IO.puts("iniciou")

    principal = self()

    consumidor =
      spawn(fn ->
        consumir_dados()
      end)

    spawn(fn ->
      dados = produzir_dados()
      send(consumidor, {:dados, dados, principal})
    end)

    IO.puts("finalizou")

    receive do
      :consumidor_terminou ->
        IO.puts("processo principal terminou")
    end
  end

end