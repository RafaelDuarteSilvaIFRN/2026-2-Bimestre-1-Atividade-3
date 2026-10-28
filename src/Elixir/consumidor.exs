
defmodule Consumidor do
  @host ~c"host.docker.internal"
  @porta 5000

  def iniciar do
    IO.puts("Consumidor conectando ao produtor...")

    case :gen_tcp.connect(@host, @porta, [:binary, active: false], 5000) do
      {:ok, socket} ->
        mensagem = "Olá do Consumidor via Socket!"

        :gen_tcp.send(socket, mensagem)
        IO.puts("Mensagem enviada!")

        case :gen_tcp.recv(socket, 0, 5000) do
          {:ok, resposta} ->
            IO.puts("Resposta recebida: #{resposta}")

          {:error, motivo} ->
            IO.inspect(motivo, label: "Erro ao receber resposta")
        end

        :gen_tcp.close(socket)

      {:error, motivo} ->
        IO.inspect(motivo, label: "Erro ao conectar ao produtor")
    end
  end
end

Consumidor.iniciar()
