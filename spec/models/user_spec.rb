require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_careers) }
    it { should have_many(:careers).through(:user_careers) }
    it { should have_many(:posts) }
    it { should have_many(:active_relationships).class_name('Relationship') }
    it { should have_many(:passive_relationships).class_name('Relationship') }
    it { should have_many(:following).through(:active_relationships) }
    it { should have_many(:followers).through(:passive_relationships) }
    it { should have_many(:comments) }
    it { should have_many(:skills) }
  end

  describe 'validations' do
    it 'validates username presence' do
      user = User.new(username: nil)
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'validates username uniqueness' do
      User.create!(email: 'user1@example.com', password: 'Password123!', 
                   username: 'testuser', firstname: 'John', lastname: 'Doe')
      user = User.new(email: 'user2@example.com', password: 'Password123!',
                      username: 'testuser', firstname: 'Jane', lastname: 'Doe')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('has already been taken')
    end

    it 'validates username length (3-20 characters)' do
      user = User.new(email: 'test@example.com', password: 'Password123!',
                      username: 'ab', firstname: 'John', lastname: 'Doe')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too short (minimum is 3 characters)')

      user.username = 'a' * 21
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too long (maximum is 20 characters)')
    end

    it 'validates email format' do
      user = User.new(email: 'invalid-email', password: 'Password123!',
                      username: 'testuser', firstname: 'John', lastname: 'Doe')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('must be a valid email address')
    end

    it 'validates email maximum length' do
      email = 'a' * 245 + '@example.com'  # Total 256 chars, over limit
      user = User.new(email: email, password: 'Password123!',
                      username: 'testuser', firstname: 'John', lastname: 'Doe')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
    end

    it 'validates bio maximum length' do
      user = User.new(email: 'test@example.com', password: 'Password123!',
                      username: 'testuser', firstname: 'John', lastname: 'Doe',
                      bio: 'a' * 501)  # Over 500 char limit
      expect(user).not_to be_valid
      expect(user.errors[:bio]).to include('is too long (maximum is 500 characters)')
    end
  end

  describe 'devise modules' do
    it 'includes database authenticatable' do
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_presence_of(:encrypted_password)
    end

    it 'includes jwt authenticatable module' do
      user = User.new(email: 'test@example.com', password: 'Password123!',
                      username: 'testuser', firstname: 'John', lastname: 'Doe')
      expect(user).to respond_to(:jwt_token)
    end
  end

  describe 'friendly_id' do
    it 'sets username as slug source' do
      user = User.create!(email: 'test@example.com', password: 'Password123!',
                          username: 'johndoe', firstname: 'John', lastname: 'Doe')
      expect(user.slug).to eq('johndoe')
    end
  end

  describe 'instance methods' do
    let(:user) { User.create!(email: 'test@example.com', password: 'Password123!',
                              username: 'testuser', firstname: 'John', lastname: 'Doe') }
    let(:other_user) { User.create!(email: 'other@example.com', password: 'Password123!',
                                    username: 'otheruser', firstname: 'Jane', lastname: 'Doe') }

    it 'follows other user' do
      expect { user.follow(other_user) }.to change { user.following.count }.by(1)
    end

    it 'unfollows other user' do
      user.follow(other_user)
      expect { user.unfollow(other_user) }.to change { user.following.count }.by(-1)
    end

    it 'checks if following another user' do
      user.follow(other_user)
      expect(user.following?(other_user)).to be true
    end

    it 'has avatar_url method' do
      expect(user).to respond_to(:avatar_url)
    end
  end
end