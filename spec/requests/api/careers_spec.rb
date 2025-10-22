require "swagger_helper"

RSpec.describe "Careers API", type: :request do
  path "/api/careers/index" do
    get "Get all careers" do
      tags "Careers"
      produces "application/json"

      response "200", "Careers retrieved successfully" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: {
                     type: :integer
                   },
                   field: {
                     type: :string,
                     example: "Software Development"
                   },
                   created_at: {
                     type: :string
                   },
                   updated_at: {
                     type: :string
                   }
                 }
               }

        run_test!
      end
    end
  end

  path "/api/careers" do
    get "Get all careers (alternative endpoint)" do
      tags "Careers"
      produces "application/json"

      response "200", "Careers retrieved successfully" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: {
                     type: :integer
                   },
                   field: {
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

        run_test!
      end
    end
  end
end
