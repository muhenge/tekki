require "swagger_helper"

RSpec.describe "Users API", type: :request do
  path "/api/users" do
    get "Get all users" do
      tags "Users"
      security [{ bearerAuth: [] }]
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
      tags "Users"
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
      tags "Users"
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
  end

  path "/api/{user_slug}/connections" do
    get "Get user connections" do
      tags "Users"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :user_slug,
                in: :path,
                type: :string,
                description: "User slug"

      response "200", "Connections retrieved" do
        schema type: :object,
               properties: {
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
                 }
               }

        let(:user_slug) { "testuser" }
        run_test!
      end
    end
  end

  path "/api/current_user_skills" do
    get "Get current user skills" do
      tags "Users"
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
