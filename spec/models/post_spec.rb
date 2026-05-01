require "rails_helper"

RSpec.describe Post, type: :model do
  describe "author assignment" do
    it "uses the owning user's username when creating a post with rich text content" do
      user = User.create!(
        email: "author@example.com",
        password: "Password1!",
        username: "author_user"
      )
      careers = [
        Career.create!(field: "Design"),
        Career.create!(field: "Engineering"),
        Career.create!(field: "Product")
      ]

      post = user.posts.create!(
        title: "Testing",
        content: '<ul class="list-disc pl-6 my-4"><li class="my-1"><p>sssss</p></li></ul><blockquote class="border-l-4 border-gray-300 pl-4 italic my-4"><p>ssssssssssssss fff</p></blockquote>',
        career_ids: careers.map(&:id)
      )

      expect(post.author).to eq("author_user")
      expect(post.careers).to match_array(careers)
    end
  end
end
