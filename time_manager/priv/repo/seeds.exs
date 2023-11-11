alias TimeManager.Repo
alias TimeManager.Users
alias TimeManager.Users.User


Repo.delete_all(User)

names = Enum.uniq(Enum.shuffle([
  "Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Harry", "Ivy", "Jack",
  "Kate", "Liam", "Mia", "Noah", "Olivia", "Parker", "Quinn", "Ryan", "Sophia", "Tyler",
  "Uma", "Victor", "Willow", "Xavier", "Yara", "Zane",
  "Ava", "Ben", "Catherine", "Daniel"
]))

for n <- 1..30 do
  name = Enum.at(names, n)
  username = name
  email = name + "@test.com"
  role =
    if is_float(n / 10) do
      if n%10 == 3 do
        "general_manager"
      else
        "manager"
      end
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
