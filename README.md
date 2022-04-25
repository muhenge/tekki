
# <span class="text-center"> API documentation </span>

<strong>base_url</strong> : ```https://huza.herokuapp.com/api/```
### <u>Authentication</u><br>
##### Body parameters:

```text
  email : string,
  username : string,
  firstname : string,
  lastname : string,
  career_id: integer
  password : string,
  confirm_password : string
```
### Endpoint:

<strong>```POST```</strong> ```{base_url}/signup```
<strong>```POST```</strong> ```{base_url}/login```
<strong>```DELETE```</strong> ```{base_url}/logout```

### <u>Posts</u><br>
##### Body parameters:

```text
  title : string,
  content : string,
  user_id : integer,
  career_id : integer,
  image : string
```
### Endpoint:

<strong>Authorization: Bearer {jwt_token}</strong>

> Create post: <strong>```POST```</strong> ```{base_url}/posts``` 
> Get all posts: <strong>```GET```</strong> ```{base_url}/posts```


<hr>

#### sign up

> <strong>```POST:```</strong> ```{base_url}/signup```


##### Body sample:

```json
{
    "user": {
        "email":"string@email.com",
        "username":"string",
        "firstname":"string",
        "lastname":"string",
        "career_id": 1,
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
<strong>201 Code response</strong>

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
    "skill_id": "skills names",
    "about": "about text",
    "bio": "bio text",
    "career_id": 1
  }
}
```
