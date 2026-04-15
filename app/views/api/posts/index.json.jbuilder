# Index view - renders array of posts
json.posts @posts do |post|
  json.partial! 'api/posts/post', post: post
end

json.user_posts @user_posts do |post|
  json.partial! 'api/posts/post', post: post
end
