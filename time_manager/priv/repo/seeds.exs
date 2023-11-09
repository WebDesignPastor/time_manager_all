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
