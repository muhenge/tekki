require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password123!', 
                            username: 'testuser', firstname: 'John', lastname: 'Doe') }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:post_careers) }
    it { should have_many(:careers).through(:post_careers) }
    it { should have_many(:skills) }
    it { should have_many(:comments) }
  end

  describe 'validations' do
    it 'validates title presence' do
      post = Post.new(content: 'This is a valid content')
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'validates title length' do
      post = Post.new(user: user, title: 'ab', content: 'This is valid content')
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include('is too short (minimum is 5 characters)')

      post.title = 'a' * 51
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include('is too long (maximum is 50 characters)')
    end

    it 'validates content presence' do
      post = Post.new(title: 'Valid Title')
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("can't be blank")
    end

    it 'validates content length' do
      post = Post.new(user: user, title: 'Valid Title', content: 'ab')
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include('is too short (minimum is 10 characters)')
    end
  end

  describe 'scopes' do
    it 'orders posts by most recent' do
      older_post = Post.create!(user: user, title: 'Old', content: 'Content')
      sleep(0.01) # Ensure different timestamps
      newer_post = Post.create!(user: user, title: 'New', content: 'Content')

      expect(Post.most_recent.first).to eq(newer_post)
    end
  end

  describe 'instance methods' do
    let(:post) { Post.create!(user: user, title: 'Test post', content: 'Content') }

    it 'has liked_by method' do
      expect(post).to respond_to(:liked_by?)
    end

    it 'has search method' do
      expect(Post).to respond_to(:search)
    end
  end
end