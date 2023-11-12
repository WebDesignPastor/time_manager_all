defmodule TimeManager.Seeds do
  alias TimeManager.Repo
  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Clocks

  ExUnit.start()
  Faker.start()

  Repo.delete_all(User)
  Repo.delete_all(WorkingTime)

  names = Enum.uniq(Enum.shuffle([
    "ahri", "akali", "alistar", "amumu", "anivia", "annie", "aphelios", "ashe", "aurelionsol", "azir",
    "bard", "blitzcrank", "brand", "braum", "caitlyn", "camille", "cassiopeia", "chogath", "corki", "darius"
  ]
  ))
  
  Users.create_user_seed(%{username: "admin", email: "admin@admin.com", password: "admin", role: "general_manager" })
  
  for n <- 0..19 do
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
    case Users.create_user_seed(user_params) do
      {:ok, %User{} = user} ->
        start_date = ~D[2023-10-20]
        end_date = Date.add(start_date, 20)
        Date.range(start_date, end_date)
        Enum.chunk_every(Date.range(start_date, end_date),5, 7)
        |> Enum.each(fn chunk ->
          for date <- chunk do
            random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 08:00:00], ~N[2023-11-11 09:00:00]))
            {_, start_time} = NaiveDateTime.new(date, random_hour)

            random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 17:00:00], ~N[2023-11-11 18:00:00]))
            {_, end_time} = NaiveDateTime.new(date, random_hour)

            case WorkingTimes.create_working_time_seed(user.id, %{start: start_time, end: end_time }) do
              {:ok, %WorkingTime{}} -> 
                random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(start_time, ~N[2023-11-11 09:00:00]))
                {_, start_time} = NaiveDateTime.new(date, random_hour)

                random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 17:00:00], end_time))
                {_, end_time} = NaiveDateTime.new(date, random_hour)

                Clocks.create_clock!(user.id, start_time, end_time, false)

              _ -> IO.inspect('fail')
            end
          end
        end)
      _ -> IO.inspect("fail")
    end
  end

  #   random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 07:00:00], ~N[2023-11-11 09:00:00]))
  #   {_, start_time} = NaiveDateTime.new(date, random_hour)

  #   random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 16:00:00], ~N[2023-11-11 18:00:00]))
  #   {_, end_time} = NaiveDateTime.new(date, random_hour)

  #   WorkingTimes.create_working_time_seed(user.id, %{start: start_time, end: end_time })

  #  start_date = ~D[2023-10-11]
  #  end_date = Date.add(start_date, 30)

  #  test = Date.range(start_date, end_date)
  #  IO.inspect(test)
  #    #Enum.chunk_every(Date.range(start_date, end_date), 7, 5, :discard)
  #    #|> Enum.each(fn chunk ->
  #    #  IO.inspect(start_date)
  #    #end)


  #  #Date.range(start_date, end_date)
  #  #|> Enum.each(fn date ->
  #  #  random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 07:00:00], ~N[2023-11-11 09:00:00]))
  #  #  {_, start_time} = NaiveDateTime.new(date, random_hour)

  #  #  random_hour = NaiveDateTime.to_time(Faker.NaiveDateTime.between(~N[2023-11-11 16:00:00], ~N[2023-11-11 18:00:00]))
  #  #  {_, end_time} = NaiveDateTime.new(date, random_hour)

  #  #  WorkingTimes.create_working_time_seed(user.id, %{start: start_time, end: end_time })
  #  #end)
  #end


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
