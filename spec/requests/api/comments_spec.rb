require "swagger_helper"

RSpec.describe "Comments API", type: :request do
  path "/api/posts/{post_id}/comments" do
    post "Create a comment on a post" do
      tags "Comments"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :post_id,
                in: :path,
                type: :integer,
                description: "Post ID"
      parameter name: :comment,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    comment: {
                      type: :object,
                      properties: {
                        text: {
                          type: :string,
                          example: "This is a great post!"
                        }
                      },
                      required: ["text"]
                    }
                  }
                }

      response "201", "Comment created successfully" do
        schema type: :object,
               properties: {
                 comment: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     text: {
                       type: :string
                     },
                     created_at: {
                       type: :string
                     },
                     user: {
                       type: :object,
                       properties: {
                         id: {
                           type: :integer
                         },
                         username: {
                           type: :string
                         }
                       }
                     }
                   }
                 },
                 message: {
                   type: :string
                 }
               }

        let(:post_id) { 1 }
        let(:comment) { { comment: { text: "Great post!" } } }

        run_test!
      end

      response "422", "Validation failed" do
        schema type: :object, properties: { error: { type: :string } }

        let(:post_id) { 1 }
        let(:comment) do
          {
            comment: {
              text: "" # Empty text
            }
          }
        end

        run_test!
      end
    end

    get "Get comments for a post" do
      tags "Comments"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :post_id,
                in: :path,
                type: :integer,
                description: "Post ID"

      response "200", "Comments retrieved successfully" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: {
                     type: :integer
                   },
                   text: {
                     type: :string
                   },
                   created_at: {
                     type: :string
                   },
                   user: {
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
               }

        let(:post_id) { 1 }
        run_test!
      end
    end
  end

  path "/api/comments/{id}" do
    delete "Delete a comment" do
      tags "Comments"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Comment ID"

      response "200", "Comment deleted successfully" do
        schema type: :object, properties: { message: { type: :string } }

        let(:id) { 1 }
        run_test!
      end

      response "403", "Not authorized" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end

      response "404", "Comment not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end
  end
end
