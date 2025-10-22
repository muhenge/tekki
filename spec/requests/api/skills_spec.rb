require "swagger_helper"

RSpec.describe "Skills API", type: :request do
  path "/api/skills" do
    post "Create user skills" do
      tags "Skills"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :skills,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    skills: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          name: {
                            type: :string,
                            example: "Ruby on Rails"
                          },
                          level: {
                            type: :string,
                            enum: %w[Beginner Intermediate Advanced],
                            example: "Intermediate"
                          }
                        },
                        required: %w[name level]
                      }
                    }
                  },
                  required: ["skills"]
                }

      response "200", "Skills created successfully" do
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
                 },
                 message: {
                   type: :string
                 }
               }

        let(:skills) do
          {
            skills: [
              { name: "Ruby on Rails", level: "Intermediate" },
              { name: "JavaScript", level: "Advanced" }
            ]
          }
        end

        run_test!
      end

      response "422", "Validation failed" do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: {
                     type: :array,
                     items: {
                       type: :string
                     }
                   }
                 }
               }

        let(:skills) do
          {
            skills: [
              {
                name: "", # Empty name
                level: "Invalid" # Invalid level
              }
            ]
          }
        end

        run_test!
      end
    end
  end

  path "/api/skills/{id}" do
    patch "Update a skill" do
      tags "Skills"
      security [{ bearerAuth: [] }]
      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Skill ID"
      parameter name: :skill,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    skill: {
                      type: :object,
                      properties: {
                        name: {
                          type: :string
                        },
                        level: {
                          type: :string,
                          enum: %w[Beginner Intermediate Advanced]
                        }
                      }
                    }
                  }
                }

      response "200", "Skill updated successfully" do
        schema type: :object,
               properties: {
                 skill: {
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
                     updated_at: {
                       type: :string
                     }
                   }
                 },
                 message: {
                   type: :string
                 }
               }

        let(:id) { 1 }
        let(:skill) { { skill: { name: "Updated Skill", level: "Advanced" } } }

        run_test!
      end

      response "404", "Skill not found" do
        schema type: :object, properties: { message: { type: :string } }

        let(:id) { 999 }
        let(:skill) { { skill: { name: "Test", level: "Beginner" } } }

        run_test!
      end
    end

    delete "Delete a skill" do
      tags "Skills"
      security [{ bearerAuth: [] }]
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, description: "Skill ID"

      response "200", "Skill deleted successfully" do
        schema type: :object, properties: { message: { type: :string } }

        let(:id) { 1 }
        run_test!
      end

      response "404", "Skill not found" do
        schema type: :object, properties: { message: { type: :string } }

        let(:id) { 999 }
        run_test!
      end
    end
  end
end
