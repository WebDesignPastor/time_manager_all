defmodule TimeManager.TokenBlacklist do
  @blacklist %{}

  def add_to_blacklist(token) do
    @blacklist = Map.put(@blacklist, token, :blacklisted)
  end

  def token_blacklisted?(token) do
    Map.has_key?(@blacklist, token)
  end
end

