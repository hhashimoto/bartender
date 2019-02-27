defmodule Bartender.Server do
  use Application
  use GenServer
  require Logger

  def start_link(state \\ []) do

    port = 8888

    dispatch =
      :cowboy_router.compile([
        {:_,
          [
            {'/ws', Bartender.WSHandler, []}
          ]
        }
      ])

    Logger.info("Started listening on port #{port}...")

    {:ok, _} = :cowboy.start_clear(:my_http_listener, [{:port, port}], %{env: %{dispatch: dispatch}})

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def start(_type, _args) do
    Logger.debug("Bartender.Server . start")
  end

  def stop(_state) do
    :ok
  end
end
