alias TimeManager.Repo
alias TimeManager.Users
alias TimeManager.Users.User



Repo.delete_all(User)

user_params = %{
  "username" => "gabin",
  "email" => "gabin@test.com",
  "password" => "gabin",
  "role" => "general_manager"
}

changeset = User.changeset(%User{}, user_params)

Repo.insert(changeset)

names = Enum.uniq(Enum.shuffle([
  "ahri", "akali", "alistar", "amumu", "anivia", "annie", "aphelios", "ashe", "aurelion sol", "azir",
  "bard", "blitzcrank", "brand", "braum", "caitlyn", "camille", "cassiopeia", "cho'gath", "corki", "darius",
  "diana", "dr. mundo", "draven", "ekko", "elise", "evelynn", "ezreal", "fiddlesticks", "fiora", "fizz"
]
))

for n <- 1..30 do
  name = Enum.at(names, rem(n, length(names) - 1) + 1)

  username = name
  email = name <> "@test.com"
  password = name
  role =
    if rem(n, 10) == 3 do
      "manager"
    else
      "employee"
    end

  manager_id =
    if role == "employee" do
      0
    else
      nil
    end

  Users.create_user_seed!(%{username: username, password: password, email: email, role: role, manager_id: manager_id})
end

# Retrieve all user IDs after insertion
user_ids = Repo.all(User) |> Enum.map(& &1.id)
IO.inspect user_ids
