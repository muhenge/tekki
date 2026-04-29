# Index view - renders array of posts
json.posts @posts do |post|
  json.partial! 'api/posts/post', post: post
end

json.user_posts @user_posts do |post|
  json.partial! 'api/posts/post', post: post
end

json.users_with_same_careers @users_with_same_careers do |user|
  json.id user.id
  json.username user.username
  json.firstname user.firstname
  json.lastname user.lastname
  json.slug user.slug
  json.avatar_url user.avatar_url
  json.careers user.careers do |career|
    json.id career.id
    json.field career.field
  end
end
