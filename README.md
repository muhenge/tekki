# REST API example application

> base_url : https://tekki.herokuapp.com/api


# REST API

The REST API to the example app is described below.

## Authentication

### Request

#### Create a new account

`POST /signup`

    curl -X POST -H "Content-Type: application/json" -d '{"user": {
        "email":"string@email.com",
        "username":"string",
        "firstname":"string",
        "lastname":"string",
        "career_id": 1,
        "password":"password",
        "password_confirmation":"password sample"
    }}' {{base_url}}/api/signup


### Response

    HTTP/1.1 201 Created
    Server: Cowboy
    Date: Thu, 05 May 2022 09:04:15 GMT
    Connection: keep-alive
    X-Runtime: 0.316885
    Transfer-Encoding: chunked
    Via: 1.1 vegur

    {"success":true,"user":{"id":4,"email":"test_curl@email.com","created_at":"2022-05-05T08:49:20.423Z","updated_at":"2022-05-05T08:49:20.423Z","firstname":"fname","lastname":"lname","username":"curl","slug":"curl","skill_id":null,"about":null,"bio":null,"career_id":1},"response":"Authentication successfully"}


#### Login

`POST /login`

    curl -X POST -H "Content-Type: application/json" -d '{"user": "email":"test@email.com", "password":"password"}}' {{base_url}}/api/login


### Response

    HTTP/1.1 200 OK
    Server: Cowboy
    Date: Thu, 05 May 2022 09:28:19 GMT
    Connection: keep-alive
    X-Frame-Options: SAMEORIGIN
    X-Xss-Protection: 0
    X-Content-Type-Options: nosniff
    X-Download-Options: noopen
    X-Permitted-Cross-Domain-Policies: none
    Referrer-Policy: strict-origin-when-cross-origin
    Content-Type: application/json; charset=utf-8
    Vary: Accept, Origin
    Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjUxNzQyODk5LCJleHAiOjE2NTMwMzg4OTksImp0aSI6ImFkMzJmNTQ3LWY1YWEtNDc4OS1iOTA2LWRlYWNjOTg2NDJkOSJ9.Xl143Z3ziQTTuct8wrLiy3FOflz84vLS3GCGjssP2wE
    Etag: W/"30e069d6f777e10ddf0e2c74dc924f7b"
    Cache-Control: max-age=0, private, must-revalidate
    X-Request-Id: ca880624-490e-4455-bcc9-7a89ecb6a4ec
    X-Runtime: 0.768774
    Transfer-Encoding: chunked
    Via: 1.1 vegur

    {"message":"Logged in successifully.","token":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjUxNzQyODk5LCJleHAiOjE2NTMwMzg4OTksImp0aSI6ImFkMzJmNTQ3LWY1YWEtNDc4OS1iOTA2LWRlYWNjOTg2NDJkOSJ9.Xl143Z3ziQTTuct8wrLiy3FOflz84vLS3GCGjssP2wE","data":{"id":5,"email":"string@email.com","created_at":"2022-05-05T09:04:15.373Z","updated_at":"2022-05-05T09:04:15.373Z","firstname":"string","lastname":"string","username":"string","slug":"string","skill_id":null,"about":null,"bio":null,"career_id":1}}

## User profile

### Request

`POST /users/username`

    curl -i -H "Accept: application/json" -H "Authorization: Bearer {token}" {{base_url}}/api/users/username
### Response

    HTTP/1.1 200 OK
    Server: Cowboy
    Date: Thu, 05 May 2022 09:28:19 GMT
    Connection: keep-alive
    X-Frame-Options: SAMEORIGIN
    X-Xss-Protection: 0
    X-Content-Type-Options: nosniff
    X-Download-Options: noopen
    X-Permitted-Cross-Domain-Policies: none
    Referrer-Policy: strict-origin-when-cross-origin
    Content-Type: application/json; charset=utf-8
    Vary: Accept, Origin
    Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjUxNzQyODk5LCJleHAiOjE2NTMwMzg4OTksImp0aSI6ImFkMzJmNTQ3LWY1YWEtNDc4OS1iOTA2LWRlYWNjOTg2NDJkOSJ9.Xl143Z3ziQTTuct8wrLiy3FOflz84vLS3GCGjssP2wE
    Etag: W/"30e069d6f777e10ddf0e2c74dc924f7b"
    Etag: W/"30e069d6f777e10ddf0e2c74dc924f7b"
    Cache-Control: max-age=0, private, must-revalidate
    X-Request-Id: ca880624-490e-4455-bcc9-7a89ecb6a4ec
    X-Runtime: 0.768774
    Transfer-Encoding: chunked
    Via: 1.1 vegur

    {"success":true,"user":{"id":5,"email":"","created_at":"2022-05-05T09:04:15.373Z","updated_at":"2022-05-05T09:04:15.373Z","firstname":"string","lastname":"string","username":"string","slug":"string","skill_id":null,"about":null,"bio":null,"career_id":1}"}

# Post

### Request

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer {token}" -d '{"post": {"title":"title text", "content":"post content text", "career_id":1}}' {{base_url}}/api/posts

### Response

    HTTP/1.1 200 OK
    Server: Cowboy
    Date: Thu, 05 May 2022 09:28:19 GMT
    Connection: keep-alive
    X-Frame-Options: SAMEORIGIN
    X-Xss-Protection: 0
    X-Content-Type-Options: nosniff
    X-Download-Options: noopen
    X-Permitted-Cross-Domain-Policies: none
    Referrer-Policy: strict-origin-when-cross-origin
    Content-Type: application/json; charset=utf-8
    Vary: Accept, Origin
    Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjUxNzQyODk5LCJleHAiOjE2NTMwMzg4OTksImp0aSI6ImFkMzJmNTQ3LWY1YWEtNDc4OS1iOTA2LWRlYWNjOTg2NDJkOSJ9.Xl143Z3ziQTTuct8wrLiy3FOflz84vLS3GCGjssP2wE
    Etag: W/"30e069d6f777e10ddf0e2c74dc924f7b"
    Cache-Control: max-age=0, private, must-revalidate
    X-Request-Id: ca880624-490e-4455-bcc9-7a89ecb6a4ec
    X-Runtime: 0.768774
    Transfer-Encoding: chunked
    Via: 1.1 vegur

    {"success":true,"post":{"id":1,"title":"title text","content":"post content text","created_at":"2022-05-05T09:04:15.373Z","updated_at":"2022-05-05T09:04:15.373Z","career_id":1}}

## Like post

    curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer {token}" {{base_url}}/api/posts/:post_id/like

## feeds

    curl -i -H "Accept: application/json" -H "Authorization: Bearer {token}" {{base_url}}/api/posts
## Build relationships

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer {token}" -d '{"followed_id": 2}' {{base_url}}/api/relationships

