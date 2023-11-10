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

names = Enum.uniq(Enum.shuffle([
  "ahri", "akali", "alistar", "amumu", "anivia", "annie", "aphelios", "ashe", "aurelion sol", "azir",
  "bard", "blitzcrank", "brand", "braum", "caitlyn", "camille", "cassiopeia", "cho'gath", "corki", "darius",
  "diana", "dr. mundo", "draven", "ekko", "elise", "evelynn", "ezreal", "fiddlesticks", "fiora", "fizz"
]))

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
      1
    else
      nil
    end

  Users.create_user_seed!(%{username: username, password: password, email: email, role: role, manager_id: manager_id})
end
