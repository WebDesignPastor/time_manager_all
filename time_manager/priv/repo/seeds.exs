# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# priv/repo/seeds.exs

alias TimeManager.Repo
alias TimeManager.Users.User

user_params = %{
  "username" => "gabin",
  "email" => "gabin@test.com",
  "password" => "gabin",
  "role" => "general_manager"
}

# Assuming you have a User.changeset function to handle the creation logic
# This function should handle password hashing and any other validation logic
changeset = User.changeset(%User{}, user_params)

case Repo.insert(changeset) do
  {:ok, _user} ->
    IO.puts "User created successfully!"
  {:error, changeset} ->
    # If there was an error, it will be shown here
    IO.inspect changeset.errors
end
