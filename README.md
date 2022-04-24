
# <span class="text-center"> API documentation </span>

<strong>base_url</strong> : ```https://huza.herokuapp.com/api/```

## Endpoint references:
<strong>```POST```</strong> ```{base_url}/signup```
<strong>```POST```</strong> ```{base_url}/login```

<hr>

### Authentication
#### sign up

<strong>```POST```</strong> ```{base_url}/signup```

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
    "email": "example@example.com",
    "created_at": "2022-04-24T15:38:37.415Z",
    "updated_at": "2022-04-24T15:38:37.415Z",
    "firstname": "fname",
    "lastname": "lname",
    "username": "example",
    "slug": "example",
    "skill_id": "",
    "about": "about sample",
    "bio": "bio sample",
    "career_id": 2
  },
  "response": "Authentication successfully"
}
```
<hr>
#### sign in 

<strong>```POST```</strong> ```{base_url}/login```

```json
{
    "user":{
        "email":"example@example.com",
        "password":"123456"
    }
}
```
<strong>Response</strong>

```json
{
  "message": "Logged in successifully.",
  "token": "jwt_token",
  "data": {
    "id": 1,
    "email": "example@email.com",
    "created_at": "2022-04-24T09:43:55.530Z",
    "updated_at": "2022-04-24T09:43:55.530Z",
    "firstname": "fname",
    "lastname": "lname",
    "username": "username",
    "slug": "slug",
    "skill_id": null,
    "about": "about text",
    "bio": "bio text",
    "career_id": 1
  }
}