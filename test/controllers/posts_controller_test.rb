require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::FileFixtureHelper
  include ActionDispatch::TestProcess
  test "should get index" do
    get posts_index_url
    assert_response :success
  end

  test "should get create" do
    get posts_create_url
    assert_response :success
  end

  test "should get show" do
    get posts_show_url
    assert_response :success
  end

  test "should create post with multiple images" do
    sign_in users(:one) # ensure fixture exists
    post_params = {
      title: "Multi Image Post",
      content: "Testing multiple images",
      images: [fixture_file_upload('files/test.png', 'image/png'), fixture_file_upload('files/test.png', 'image/png')]
    }
    post api_posts_url, params: { post: post_params }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert json["images"].present?, "Response should include images"
  end
end
