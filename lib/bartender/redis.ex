defmodule Bartender.Redis do

  # keysに該当するvaluesの存在する個数を返す
  def exists(conn, keys) do
    Redix.command!(conn, ["EXISTS", keys])
  end

  # https://redis.io/commands/set
  # SET key value [expiration EX seconds|PX milliseconds] [NX|XX]
  def set(conn, key, value) do
    Redix.command!(conn, ["SET", key, value])
  end

  def get(conn, key) do
    Redix.command!(conn, ["GET", key])
  end

  def del(conn, keys) do
    Redix.command!(conn, ["DEL", keys])
  end

  def sadd(conn, key, members) do
    Redix.command!(conn, ["SADD", key, members])
  end

  def srem(conn, key, members) do
    Redix.command!(conn, ["SREM", key, members])
  end

end
