require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "admin", email: "admin@a.a", password: "pass", admin: true)
    @d_user = User.create(username: "user", email: "user@u.u", password: "pass", admin: true)
    sign_in_as(@admin_user)
  end


  test "get new category form and create category" do
    get "/categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_url, params: { category: { name: "Sports" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Sports", response.body
    end

  test "get new category form and create submission" do
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_url, params: { category: { name: "" } }
    end
    assert_match "errors", response.body
    assert_select 'div.article-error'
  end

end
