require "swagger_helper"

RSpec.describe "Users API", type: :request do
  path "/api/users" do
    get "Get all users" do
      tags "Users", "Public"
      security []
      produces "application/json"

      parameter name: :page,
                in: :query,
                type: :integer,
                required: false,
                description: "Page number"
      parameter name: :per_page,
                in: :query,
                type: :integer,
                required: false,
                description: "Items per page"

      response "200", "Users retrieved successfully" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 users: {
                   type: :array,
                   items: {
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
                       bio: {
                         type: :string
                       },
                       about: {
                         type: :string
                       },
                       created_at: {
                         type: :string
                       },
                       updated_at: {
                         type: :string
                       }
                     }
                   }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: {
                       type: :integer
                     },
                     next_page: {
                       type: :integer
                     },
                     prev_page: {
                       type: :integer
                     },
                     total_pages: {
                       type: :integer
                     },
                     total_count: {
                       type: :integer
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

  path "/api/users/{slug}" do
    get "Get user by slug" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :slug, in: :path, type: :string, description: "User slug"

      response "200", "User found" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 message: {
                   type: :string
                 },
                 user: {
                   type: :object,
                   properties: {
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
                         bio: {
                           type: :string
                         },
                         about: {
                           type: :string
                         }
                       }
                     },
                     career: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: {
                             type: :integer
                           },
                           field: {
                             type: :string
                           }
                         }
                       }
                     },
                     followers_count: {
                       type: :integer
                     },
                     following_count: {
                       type: :integer
                     },
                     posts_count: {
                       type: :integer
                     },
                     skills_count: {
                       type: :integer
                     },
                     followers: {
                       type: :array,
                       items: {
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
                     },
                     following: {
                       type: :array,
                       items: {
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
                     },
                     posts: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: {
                             type: :integer
                           },
                           title: {
                             type: :string
                           },
                           content: {
                             type: :string
                           },
                           author: {
                             type: :string
                           },
                           slug: {
                             type: :string
                           },
                           created_at: {
                             type: :string
                           }
                         }
                       }
                     },
                     skills: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: {
                             type: :integer
                           },
                           name: {
                             type: :string
                           },
                           level: {
                             type: :string
                           }
                         }
                       }
                     }
                   }
                 }
               }

        let(:slug) { "testuser" }
        run_test!
      end

      response "404", "User not found" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 message: {
                   type: :string
                 }
               }

        let(:slug) { "nonexistent" }
        run_test!
      end
    end

    patch "Update user profile" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :slug, in: :path, type: :string, description: "User slug"
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        firstname: {
                          type: :string
                        },
                        lastname: {
                          type: :string
                        },
                        username: {
                          type: :string
                        },
                        bio: {
                          type: :string
                        },
                        about: {
                          type: :string
                        },
                        avatar: {
                          type: :string,
                          format: :binary
                        }
                      }
                    }
                  }
                }

      response "200", "User updated successfully" do
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
                     bio: {
                       type: :string
                     }
                   }
                 }
               }

        let(:slug) { "testuser" }
        let(:user) do
          {
            user: {
              firstname: "Updated",
              lastname: "Name",
              bio: "Updated bio"
            }
          }
        end

        run_test!
      end

      response "422", "Validation failed" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 errors: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 }
               }

        let(:slug) { "testuser" }
        let(:user) do
          {
            user: {
              username: "a" # Too short
            }
          }
        end

        run_test!
      end
    end

    post "Follow user" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :slug, in: :path, type: :string, description: "User slug"

      response "201", "Relationship created successfully" do
        let(:slug) { "testuser" }
        run_test!
      end
    end

    delete "Unfollow user" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :slug, in: :path, type: :string, description: "User slug"

      response "200", "Relationship destroyed successfully" do
        let(:slug) { "testuser" }
        run_test!
      end
    end

    path "/api/users/{slug}/avatar" do
      post "Upload user avatar" do
        tags "Users", "Protected"
        security [{ bearerAuth: [] }]
        consumes "multipart/form-data"
        produces "application/json"

        parameter name: :slug, in: :path, type: :string, description: "User slug"
        parameter name: :avatar, in: :formData, type: :file, required: true, description: "Avatar image file"

        response "200", "Avatar uploaded successfully" do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string },
                   avatar_url: { type: :string }
                 }

          let(:slug) { "testuser" }
          let(:avatar) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png") }
          run_test!
        end

        response "400", "No avatar provided" do
          let(:slug) { "testuser" }
          let(:avatar) { nil }
          run_test!
        end

        response "422", "Validation failed" do
          let(:slug) { "testuser" }
          let(:avatar) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test.txt"), "text/plain") }
          run_test!
        end
      end
    end
  end

  path "/api/users/{slug}/connections" do
    get "Get user connections" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :slug,
                in: :path,
                type: :string,
                description: "User slug"

      response "200", "Connections retrieved" do
        schema type: :object,
               properties: {
                 success: {
                   type: :boolean
                 },
                 followers: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       userId: {
                         type: :integer
                       },
                       username: {
                         type: :string
                       },
                       slug: {
                         type: :string
                       },
                       relationshipId: {
                         type: :integer
                       },
                       isFollowing: {
                         type: :boolean
                       },
                       redirectTo: {
                         type: :string
                       }
                     }
                   }
                 },
                 following: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       userId: {
                         type: :integer
                       },
                       username: {
                         type: :string
                       },
                       slug: {
                         type: :string
                       },
                       relationshipId: {
                         type: :integer
                       },
                       isFollowing: {
                         type: :boolean
                       },
                       redirectTo: {
                         type: :string
                       }
                     }
                   }
                 }
               }

        let(:slug) { "testuser" }
        run_test!
      end
    end
  end

  path "/api/current_user_skills" do
    get "Get current user skills" do
      tags "Users", "Protected"
      security [{ bearerAuth: [] }]
      produces "application/json"

      response "200", "Skills retrieved" do
        schema type: :object,
               properties: {
                 skills: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: {
                         type: :integer
                       },
                       name: {
                         type: :string
                       },
                       level: {
                         type: :string
                       },
                       created_at: {
                         type: :string
                       }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end
end
