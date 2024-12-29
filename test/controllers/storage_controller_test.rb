require "test_helper"

class StorageControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get storage_test_url
    assert_response :success
  end
end
