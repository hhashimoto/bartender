defmodule Bartender.Manager do

  # uid: public_user_id
  def join(uid) do
    if Bartender.Redis.exists(:redix, uid) == 0 do
      room_no = Enum.random(1..1_000)
      Bartender.Redis.set(:redix, uid, room_no)
      # Enumで生成した数値はinteger, Redisのvalueはstring
      Bartender.Redis.sadd(:redix, "room_" <> Integer.to_string(room_no), uid)
      room_no
    else
      room_no = Bartender.Redis.get(:redix, uid)
      room_no
    end
  end

  def leave(uid) do
    if Bartender.Redis.exists(:redix, uid) != 0 do
      room_no = Bartender.Redis.get(:redix, uid)
      Bartender.Redis.srem(:redix, "room_" <> room_no, uid)
      Bartender.Redis.del(:redix, uid)
    end
  end

end
