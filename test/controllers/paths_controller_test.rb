require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  setup do
    @path = paths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paths)
  end

  test "should create path" do
    assert_difference('Path.count') do
      post :create, path: {  }
    end

    assert_response 201
  end

  test "should show path" do
    get :show, id: @path
    assert_response :success
  end

  test "should update path" do
    put :update, id: @path, path: {  }
    assert_response 204
  end

  test "should destroy path" do
    assert_difference('Path.count', -1) do
      delete :destroy, id: @path
    end

    assert_response 204
  end
end
