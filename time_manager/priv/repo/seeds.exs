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

Application.load(:time_manager)

alias TimeManager.Repo
alias TimeManager.Users
alias TimeManager.Users.User

Repo.delete_all(User)
TimeManager.Users.User.create_user(%{email: "test@test.com", username: "test"})


