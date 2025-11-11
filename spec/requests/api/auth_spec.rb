require 'rails_helper'

RSpec.describe 'Api::Auth', type: :request do
  describe 'POST /api/auth/signup' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'Password123!',
          password_confirmation: 'Password123!',
          username: 'testuser',
          firstname: 'John',
          lastname: 'Doe',
          bio: 'Software developer'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: 'invalid-email',
          password: '123',
          password_confirmation: '456',
          username: '', # Invalid - empty
          firstname: '',
          lastname: ''
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post '/api/auth/signup', params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['user']['email']).to eq('test@example.com')
        expect(json_response['user']['username']).to eq('testuser')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        post '/api/auth/signup', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
      end
    end
  end

  describe 'POST /api/auth/login' do
    let(:user) do
      User.create!(
        email: 'test@example.com',
        password: 'Password123!',
        username: 'testuser',
        firstname: 'John',
        lastname: 'Doe'
      )
    end

    let(:valid_login_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'Password123!'
        }
      }
    end

    let(:invalid_login_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'wrongpassword'
        }
      }
    end

    context 'with valid credentials' do
      it 'returns authentication token' do
        post '/api/auth/login', params: valid_login_params
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['data']['email']).to eq('test@example.com')
        expect(json_response['data']['username']).to eq('testuser')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/api/auth/login', params: invalid_login_params
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end
end