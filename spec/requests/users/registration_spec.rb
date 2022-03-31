require 'swagger_helper'

RSpec.describe 'users/registration', type: :request do
  path "/api/signup" do
    post "Create an user" do
      tags "Users"
      consumes "application/json"
      parameter 
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          username: { type: :string },
          firstname: { type: :string },
          lastname: { type: :string },
          bio: { type: :text },
          about: { type: :text },
          career_id: { type: :integer },
        },
        required: ["email","password","career_id"],
      }
response "201", "Signed up successfully" do
        let(:user) { { email: 'test@gmail.com'} }
        run_test!
      end
response "422", "invalid request" do
        let(:user) { { email: 'test@gmail' } }
        run_test!
      end
    end
  end
end
