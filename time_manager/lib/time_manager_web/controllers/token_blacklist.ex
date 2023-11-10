defmodule TimeManager.TokenBlacklist do

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.JwtBlacklist

  def add_to_blacklist(token) do
    %JwtBlacklist{}
    |> JwtBlacklist.changeset(%{token: token}) 
    |> Repo.insert()
  end

  def token_blacklisted?(token) do
    JwtBlacklist
    |> where(token: ^token)
    |> Repo.one()
  end
end
