
defmodule Produtor do
  @porta 5000

  def iniciar do
    {:ok, servidor} =
      :gen_tcp.listen(@porta, [
        :binary,
        active: false,
        reuseaddr: true,
        ip: {0, 0, 0, 0}
      ])

    IO.puts("PRODUTOR aguardando conexões na porta #{@porta}...")
    aguardar_conexao(servidor)
  end

  defp aguardar_conexao(servidor) do
    case :gen_tcp.accept(servidor) do
      {:ok, cliente} ->
        IO.puts("Cliente conectado!")

        case :gen_tcp.recv(cliente, 0, 5000) do
          {:ok, mensagem} ->
            IO.puts("Mensagem recebida: #{mensagem}")

            resposta = "Mensagem recebida com sucesso!"
            :gen_tcp.send(cliente, resposta)

          {:error, motivo} ->
            IO.inspect(motivo, label: "Erro ao receber mensagem")
        end

        :gen_tcp.close(cliente)
        aguardar_conexao(servidor)

      {:error, motivo} ->
        IO.inspect(motivo, label: "Erro ao aceitar conexão")
    end
  end
end

Produtor.iniciar()
