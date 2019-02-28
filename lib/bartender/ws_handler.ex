defmodule Bartender.WSHandler do

  require Logger

  def init(req, state) do
    Logger.info("wshandler.init")
    opts = %{idle_timeout: 60000}

    {:cowboy_websocket, req, state, opts}
  end

  def websocket_init(state) do
    Logger.info("started connection.")

    Registry.register(:client_registry, :clients, [])
    {:ok, state}
  end

  def websocket_handle({:text, message}, state) do
    message = String.trim(message)
    rep = case message do
      "join" ->
        Registry.dispatch(:client_registry, :clients, fn entries ->
          for {pid, _} <- entries do
            send(pid, {:broadcast, "test broadcast"})
          end
        end)
        "welcome!"
      "leave" -> "bye!"
      _ -> "rep >>> " <> message
    end
    {:reply, {:text, rep}, state}
  end

  def websocket_handle({:binary, body}, state) do
    list = body
          |> Msgpax.unpack!()

    # list = ["join", <uid>]
    IO.inspect(list)

    [cmd, uid] = list

    resp = case cmd do
      "join" ->
        Registry.dispatch(:client_registry, :clients, fn entries ->
          for {pid, _} <- entries do
            send(pid, {:broadcast, "test broadcast"})
          end
        end)
        room_no = Bartender.Manager.join(uid)
        ["welcome!", uid, room_no]
      "leave" ->
        Bartender.Manager.leave(uid)
        send(self(), :close)
        ["bye!", uid]
      _ -> ["unknown", uid]
    end

    rep = resp
          |> Msgpax.pack!()

    {:reply, {:binary, rep}, state}
  end

  def websocket_handle(_data = {type, body}, state) do
    Logger.info("handle: type = " <> type <> ", body = " <> body)
    {:ok, state}
  end

  def websocket_info({:broadcast, message}, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_info(:message, state) do
    resp = ["message", 0]
    rep = resp |> Msgpax.pack!()
    {:reply, {:binary, rep}, state}
  end

  def websocket_info(:close, state) do
    Logger.info("info: close")
    {:stop, state}
  end

  def websocket_info(:foo, state) do
    {:ok, state}
  end

  def terminate(_reason, _req, _state) do
    Logger.info("connection terminated")
    :ok
  end
end
