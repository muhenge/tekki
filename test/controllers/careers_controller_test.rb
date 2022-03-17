require "test_helper"

class CareersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get careers_index_url
    assert_response :success
  end
end
