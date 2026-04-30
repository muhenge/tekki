json.id post.id
json.title post.title
json.content post.content
json.created_at post.created_at
json.updated_at post.updated_at
json.slug post.slug if post.respond_to?(:slug)
json.author post.author
json.author_slug post.user&.slug
json.can_manage current_user == post.user if current_user

# Author/User object
if post.user
  json.user do
    json.id post.user.id
    json.username post.user.username
    json.firstname post.user.firstname
    json.lastname post.user.lastname
    json.email post.user.email
    json.bio post.user.bio
    json.about post.user.about
    json.slug post.user.slug
    json.avatar_url post.user.avatar_url if post.user.respond_to?(:avatar_url)
  end
else
  json.user nil
end

# Careers
if post.careers.any?
  json.careers post.careers do |career|
    json.id career.id
    json.field career.field
  end
else
  json.careers []
end

# Comments
if post.comments.any?
  json.comments post.comments.order(created_at: :desc) do |comment|
    json.id comment.id
    json.text comment.text
    json.created_at comment.created_at
    json.updated_at comment.updated_at
    if comment.user
      json.user do
        json.id comment.user.id
        json.username comment.user.username
        json.slug comment.user.slug
      end
    else
      json.user nil
    end
  end
else
  json.comments []
end

# Voting/Likes
json.votes_count post.get_upvotes.size
json.liked_by_current_user current_user.liked?(post) if current_user
