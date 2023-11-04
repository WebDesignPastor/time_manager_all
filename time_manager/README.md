# TimeManager

## USER
**Get all users**\
 `http://localhost:4000/api/users`

**Get user by username and email**\
`http://localhost:4000/api/users?username=XXX&email=YYY`
 
**Create user**\
`http://localhost:4000/api/users`
```
{
  "user": {
    "username": "test2",
    "email": "test2@test.com"
  }
}
```
**Update user**\
`http://localhost:4000/api/users/:userID`

**Delete user**\
`http://localhost:4000/api/users/:userID`
## WORKING TIME
**Get working times between start and end**\
`http://localhost:4000/api/workingtimes/1?start=XXX&end=YYY`

**Get specific working time**\
`http://localhost:4000/api/workingtimes/:userID/:id`

**Create working times**\
`http://localhost:4000/api/workingtimes/:userID`
```
{
    "working_time": {
        "start": "2023-10-27T12:34:56Z",
        "end": "2023-10-27T19:34:56Z"
    }
}
```
**Update working time**\
`http://localhost:4000/api/workingtimes/:id`
```
{
    "working_time": {
        "start": "2023-10-27T12:34:56Z",
        "end": "2023-10-27T19:34:56Z"
    }
}
```
**Delete working time**\
`http://localhost:4000/api/workingtimes/:id`
## CLOCK
**Get clock**\
`http://localhost:4000/api/clocks/:userID`
**Create clock**\
`http://localhost:4000/api/clocks/:userID`
```
{
	"clock":  {
	"time":  "2023-10-27T12:34:56Z",
	"status":  true
	}
}
```
