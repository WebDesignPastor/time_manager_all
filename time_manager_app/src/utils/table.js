export const onlyUsers = (users, currUser) => {
  let userToDisplay = []

  users.forEach(user => {
    if (user.username != currUser) {
      userToDisplay.push(user)
    }
  });
  return userToDisplay
}
