defmodule Bartender.WSHandler do

  require Logger

  def init(req, state) do
    Logger.info("wshandler.init")
    opts = %{idle_timeout: 60000}

    {:cowboy_websocket, req, state, opts}
  end

  def websocket_init(state) do
    Logger.info("started connection.")
    {:ok, state}
  end

  def websocket_handle({:text, message}, state) do
    {:reply, {:text, "rep >>> " <> message}, state}
  end

  def websocket_handle(_data, state) do
    {:ok, state}
  end

  def websocket_info(:foo, state) do
    {:ok, state}
  end

  def terminate(_reason, _req, _state) do
    Logger.info("connection terminated")
    :ok
  end
end
