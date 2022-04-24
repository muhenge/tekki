
# <span class="text-center"> API documentation </span>

>base_url : ```https://huza.herokuapp.com/api/```

## Endpoint references:

### Authentication
#### sign up
#### <strong>```POST```</strong> ```{base_url}/signup```

<strong>Body</strong>
```json
{
  "user:": {
        "email":"example@email.com",
        "username":"example",
        "firstname":"fname",
        "lastname":"lname",
        "career_id":2,
        "bio":"bio sample",
        "about":"about sample",
        "password":"password sample",
        "password_confirmation":"password sample"
    }
}
```
<strong>Response</strong>
```json
{
  "success": true,
  "user": {
    "id": 2,
    "email": "example@example.com"",
    "created_at": "2022-04-24T15:38:37.415Z",
    "updated_at": "2022-04-24T15:38:37.415Z",
    "firstname": "fname",
    "lastname": "lname",
    "username": "example",
    "slug": "example",
    "skill_id": null,
    "about": "about sample",
    "bio": "bio sample",
    "career_id": 2
  },
  "response": "Authentication successfully"
}
```