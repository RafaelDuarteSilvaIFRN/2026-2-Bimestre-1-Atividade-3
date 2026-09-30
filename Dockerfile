FROM elixir:1.17

WORKDIR /app

COPY src/Elixir/ .

CMD ["elixir", "exemplo_main.exs"]