alias TimeManager.Repo
alias TimeManager.Users
alias TimeManager.Users.User

# Delete all users
Repo.delete_all(User)

# Define a list of names
names = Enum.uniq(Enum.shuffle([
  "Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Harry", "Ivy", "Jack",
  "Kate", "Liam", "Mia", "Noah", "Olivia", "Parker", "Quinn", "Ryan", "Sophia", "Tyler",
  "Uma", "Victor", "Willow", "Xavier", "Yara", "Zane",
  "Ava", "Ben", "Catherine", "Daniel"
]))

# Loop to create users
for n <- 1..30 do
  # Use a safe way to get a name from the list
  name = Enum.at(names, rem(n, length(names) - 1) + 1)

  username = name
  email = name <> "@test.com"
  role =
    if rem(n, 10) == 3 do
      "general_manager"
    else
      "employee"
    end

  manager_id =
    if role == "employee" do
      1
    else
      nil
    end

  Users.create_user_seed!(%{username: username, email: email, role: role, manager_id: manager_id})
end
