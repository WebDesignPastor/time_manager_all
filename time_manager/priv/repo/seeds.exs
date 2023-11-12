defmodule TimeManager.Seeds do
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.WorkingTimes
  alias TimeManager.Users.User

  ExUnit.start()
  Faker.start()

  Repo.delete_all(User)

  names = Enum.uniq(Enum.shuffle([
    "ahri", "akali", "alistar", "amumu", "anivia", "annie", "aphelios", "ashe", "aurelionsol", "azir",
    "bard", "blitzcrank", "brand", "braum", "caitlyn", "camille", "cassiopeia", "chogath", "corki", "darius",
    "diana", "dr.mundo", "draven", "ekko", "elise", "evelynn", "ezreal", "fiddlesticks", "fiora", "fizz"
  ]
  ))

  Users.create_user_seed!(%{username: "admin", email: "email@admin.com", password: "admin", role: "general_manager" })

  for n <- 0..29 do
    name = Enum.at(names, n)
    user_params = %{
      "username" => name,
      "email" => name <> "@test.com",
      "password" => name,
      "role" =>
        if rem(n, 3) == 0 do
          "manager"
        else
          "employee"
        end
    }
    {_, user} = Users.create_user_seed!(user_params)

    start_date = ~D[2023-10-11]
    end_date = Date.add(start_date, 30)

    Date.range(start_date, end_date)
    |> Enum.each(fn date ->
      random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 07:00:00], ~N[2023-11-11 09:00:00]))
      {_, start_time} = NaiveDateTime.new(date, random_hour)

      random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 16:00:00], ~N[2023-11-11 18:00:00]))
      {_, end_time} = NaiveDateTime.new(date, random_hour)

      WorkingTimes.create_working_time_seed(user.id, %{start: start_time, end: end_time })
    end)
  end
end
#Repo.delete_all(User)
#
#user_params = %{
#  "username" => "gabin",
#  "email" => "gabin@test.com",
#  "password" => "gabin",
#  "role" => "general_manager"
#}
#
#changeset = User.changeset(%User{}, user_params)
#
#Repo.insert(changeset)
#
#names = Enum.uniq(Enum.shuffle([
#  "ahri", "akali", "alistar", "amumu", "anivia", "annie", "aphelios", "ashe", "aurelion sol", "azir",
#  "bard", "blitzcrank", "brand", "braum", "caitlyn", "camille", "cassiopeia", "cho'gath", "corki", "darius",
#  "diana", "dr. mundo", "draven", "ekko", "elise", "evelynn", "ezreal", "fiddlesticks", "fiora", "fizz"
#]
#))
#
#for n <- 1..30 do
#  name = Enum.at(names, rem(n, length(names) - 1) + 1)
#
#  username = name
#  email = name <> "@test.com"
#  password = name
#  role =
#    if rem(n, 10) == 3 do
#      "manager"
#    else
#      "employee"
#    end
#
#  Users.create_user_seed!(%{username: username, password: password, email: email, role: role})
#end
#
## Retrieve all user IDs after insertion
#user_ids = Repo.all(User) |> Enum.map(& &1.id)
#IO.inspect user_ids
