
# <span class="text-center"> API documentation </span>

<strong>base_url</strong> : ```https://huza.herokuapp.com/api/```
## Authentication

### Endpoint:
<strong>```POST```</strong> ```{base_url}/signup```
<strong>```POST```</strong> ```{base_url}/login```

<hr>

#### sign up

> <strong>```POST:```</strong> ```{base_url}/signup```

##### Body parameters:

```text
  email : string,
  username : string,
  firstname : string,
  lastname : string,
  career_id: integer
  password : string,
  confirm_password : string
  bio:text,
  about:text
```
##### Body sample:

```json
{
    "user": {
        "email":"string",
        "username":"string",
        "firstname":"string",
        "lastname":"string",
        "career_id": 1,
        "bio":"text",
        "about":"text",
        "password":"password",
        "password_confirmation":"password sample"
    }
}
```

#### sign in 

> <strong>```POST```</strong> ```{base_url}/login```

##### Body sample:


```json
{
    "user":{
        "email":"example@example.com",
        "password":"123456"
    }
}
```
<strong>Response sample</strong>

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