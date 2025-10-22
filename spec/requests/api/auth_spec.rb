require "swagger_helper"

RSpec.describe "Authentication API", type: :request do
  path "/api/auth/signup" do
    post "Create a new user account" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: {
                          type: :string,
                          example: "user@example.com"
                        },
                        password: {
                          type: :string,
                          example: "password123"
                        },
                        password_confirmation: {
                          type: :string,
                          example: "password123"
                        },
                        username: {
                          type: :string,
                          example: "johndoe"
                        },
                        firstname: {
                          type: :string,
                          example: "John"
                        },
                        lastname: {
                          type: :string,
                          example: "Doe"
                        },
                        bio: {
                          type: :string,
                          example: "Software developer"
                        },
                        about: {
                          type: :string,
                          example: "Passionate about technology"
                        }
                      },
                      required: %w[
                        email
                        password
                        password_confirmation
                        username
                        firstname
                        lastname
                      ]
                    }
                  }
                }

      response "201", "User created successfully" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     email: {
                       type: :string
                     },
                     username: {
                       type: :string
                     },
                     firstname: {
                       type: :string
                     },
                     lastname: {
                       type: :string
                     },
                     slug: {
                       type: :string
                     },
                     created_at: {
                       type: :string
                     },
                     updated_at: {
                       type: :string
                     }
                   }
                 },
                 message: {
                   type: :string
                 }
               }

        let(:user) do
          {
            user: {
              email: "test@example.com",
              password: "password123",
              password_confirmation: "password123",
              username: "testuser",
              firstname: "Test",
              lastname: "User"
            }
          }
        end

        run_test!
      end

      response "422", "Invalid request" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 errors: {
                   type: :object
                 }
               }

        let(:user) do
          {
            user: {
              email: "invalid-email",
              password: "123",
              password_confirmation: "456"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/auth/login" do
    post "User login" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: {
                          type: :string,
                          example: "user@example.com"
                        },
                        password: {
                          type: :string,
                          example: "password123"
                        }
                      },
                      required: %w[email password]
                    }
                  }
                }

      response "200", "Login successful" do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 },
                 data: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     email: {
                       type: :string
                     },
                     username: {
                       type: :string
                     },
                     firstname: {
                       type: :string
                     },
                     lastname: {
                       type: :string
                     },
                     slug: {
                       type: :string
                     }
                   }
                 }
               }

        let(:user) do
          { user: { email: "test@example.com", password: "password123" } }
        end

        run_test!
      end

      response "401", "Invalid credentials" do
        schema type: :object, properties: { error: { type: :string } }

        let(:user) do
          { user: { email: "wrong@example.com", password: "wrongpassword" } }
        end

        run_test!
      end
    end
  end

  path "/api/auth/logout" do
    delete "User logout" do
      tags "Authentication"
      security [{ bearerAuth: [] }]
      produces "application/json"

      response "200", "Logout successful" do
        schema type: :object, properties: { message: { type: :string } }

        run_test!
      end
    end
  end

  path "/api/auth/current_user" do
    get "Get current user information" do
      tags "Authentication"
      security [{ bearerAuth: [] }]
      produces "application/json"

      response "200", "Current user retrieved" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     email: {
                       type: :string
                     },
                     username: {
                       type: :string
                     },
                     firstname: {
                       type: :string
                     },
                     lastname: {
                       type: :string
                     },
                     slug: {
                       type: :string
                     }
                   }
                 }
               }

        run_test!
      end

      response "401", "Unauthorized" do
        schema type: :object, properties: { error: { type: :string } }

        run_test!
      end
    end
  end

  path "/api/auth/magic_login" do
    post "Magic login with token" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :token,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    token: {
                      type: :string,
                      example: "abc123def456"
                    }
                  },
                  required: ["token"]
                }

      response "200", "Magic login successful" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 user: {
                   type: :object,
                   properties: {
                     id: {
                       type: :integer
                     },
                     email: {
                       type: :string
                     },
                     username: {
                       type: :string
                     }
                   }
                 }
               }

        let(:token) { { token: "valid_token" } }
        run_test!
      end

      response "401", "Invalid token" do
        schema type: :object, properties: { error: { type: :string } }

        let(:token) { { token: "invalid_token" } }
        run_test!
      end
    end
  end
end
