require "swagger_helper"

RSpec.describe "Posts API", type: :request do
  path "/api/posts" do
    get "Get all posts (feed)" do
      tags "Posts"
      security [{ bearerAuth: [] }]
      produces "application/json"

      response "200", "Posts retrieved successfully" do
        schema type: :object,
               properties: {
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
                       },
                       updated_at: {
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
                       },
                       comments: {
                         type: :array,
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
                             }
                           }
                         }
                       }
                     }
                   }
                 },
                 user_posts: {
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
                 }
               }

        run_test!
      end

      response "401", "Unauthorized" do
        schema type: :object, properties: { error: { type: :string } }

        run_test!
      end
    end

    post "Create a new post" do
      tags "Posts"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :post,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    post: {
                      type: :object,
                      properties: {
                        title: {
                          type: :string,
                          example: "My Post Title"
                        },
                        content: {
                          type: :string,
                          example: "This is the content of my post"
                        },
                        image: {
                          type: :string,
                          format: :binary
                        },
                        career_ids: {
                          type: :array,
                          items: {
                            type: :integer
                          },
                          example: [1, 2]
                        }
                      },
                      required: %w[title content]
                    }
                  }
                }

      response "201", "Post created successfully" do
        schema type: :object,
               properties: {
                 post: {
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

        let(:post) do
          {
            post: {
              title: "Test Post",
              content: "This is a test post content"
            }
          }
        end

        run_test!
      end

      response "422", "Validation failed" do
        schema type: :object,
               properties: {
                 error: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 }
               }

        let(:post) do
          {
            post: {
              title: "Hi", # Too short
              content: "Short" # Too short
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/posts/{id}" do
    get "Get post by ID" do
      tags "Posts"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Post ID"

      response "200", "Post found" do
        schema type: :object,
               properties: {
                 post: {
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
                     },
                     updated_at: {
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
                 },
                 comments: {
                   type: :array,
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
                           }
                         }
                       }
                     }
                   }
                 }
               }

        let(:id) { 1 }
        run_test!
      end

      response "404", "Post not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end

    patch "Update post" do
      tags "Posts"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Post ID"
      parameter name: :post,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    post: {
                      type: :object,
                      properties: {
                        title: {
                          type: :string
                        },
                        content: {
                          type: :string
                        },
                        image: {
                          type: :string,
                          format: :binary
                        },
                        career_ids: {
                          type: :array,
                          items: {
                            type: :integer
                          }
                        }
                      }
                    }
                  }
                }

      response "200", "Post updated successfully" do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 },
                 post: {
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
                     updated_at: {
                       type: :string
                     }
                   }
                 }
               }

        let(:id) { 1 }
        let(:post) do
          { post: { title: "Updated Title", content: "Updated content" } }
        end

        run_test!
      end

      response "422", "Validation failed" do
        schema type: :object,
               properties: {
                 error: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 }
               }

        let(:id) { 1 }
        let(:post) do
          {
            post: {
              title: "Hi" # Too short
            }
          }
        end

        run_test!
      end
    end

    delete "Delete post" do
      tags "Posts"
      security [{ bearerAuth: [] }]

      parameter name: :id, in: :path, type: :integer, description: "Post ID"

      response "204", "Post deleted successfully" do
        let(:id) { 1 }
        run_test!
      end

      response "404", "Post not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end
  end

  path "/api/posts/{id}/like" do
    put "Like/Unlike a post" do
      tags "Posts"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Post ID"

      response "200", "Post liked/unliked successfully" do
        schema type: :object, properties: { message: { type: :string } }

        let(:id) { 1 }
        run_test!
      end

      response "404", "Post not found" do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end
  end
end
