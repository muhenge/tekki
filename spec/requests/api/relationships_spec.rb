require "swagger_helper"

RSpec.describe "Relationships API", type: :request do
  path "/api/relationships" do
    post "Follow a user" do
      tags "Relationships"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :relationship,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    followed_id: {
                      type: :integer,
                      example: 2,
                      description: "ID of user to follow"
                    }
                  },
                  required: ["followed_id"]
                }

      response "201", "Relationship created successfully" do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 },
                 followed_user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     username: {
                       type: :string
                     },
                     slug: {
                       type: :string
                     }
                   }
                 }
               }

        let(:relationship) { { followed_id: 2 } }

        run_test!
      end

      response "404", "User not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:relationship) { { followed_id: 999 } }

        run_test!
      end

      response "422", "Cannot follow yourself" do
        schema type: :object, properties: { error: { type: :string } }

        let(:relationship) do
          {
            followed_id: 1 # Same as current user
          }
        end

        run_test!
      end
    end
  end

  path "/api/relationships/{id}" do
    delete "Unfollow a user" do
      tags "Relationships"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :id,
                in: :path,
                type: :integer,
                description: "Relationship ID"

      response "200", "Relationship destroyed successfully" do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 },
                 unfollowed_user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     username: {
                       type: :string
                     },
                     slug: {
                       type: :string
                     }
                   }
                 }
               }

        let(:id) { 1 }
        run_test!
      end

      response "404", "Relationship not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end
  end
end
