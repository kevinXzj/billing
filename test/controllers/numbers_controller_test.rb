require 'test_helper'

class NumbersControllerTest < ActionController::TestCase
  setup do
    @number = numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create number" do
    assert_difference('Number.count') do
      post :create, number: { apply_at: @number.apply_at, company_id: @number.company_id, phone_num: @number.phone_num, real_number: @number.real_number }
    end

    assert_redirected_to number_path(assigns(:number))
  end

  test "should show number" do
    get :show, id: @number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @number
    assert_response :success
  end

  test "should update number" do
    patch :update, id: @number, number: { apply_at: @number.apply_at, company_id: @number.company_id, phone_num: @number.phone_num, real_number: @number.real_number }
    assert_redirected_to number_path(assigns(:number))
  end

  test "should destroy number" do
    assert_difference('Number.count', -1) do
      delete :destroy, id: @number
    end

    assert_redirected_to numbers_path
  end
end
