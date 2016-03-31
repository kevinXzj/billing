require 'test_helper'

class BillItemsControllerTest < ActionController::TestCase
  setup do
    @bill_item = bill_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bill_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bill_item" do
    assert_difference('BillItem.count') do
      post :create, bill_item: { bill: @bill_item.bill, internet: @bill_item.internet, message: @bill_item.message, proxy: @bill_item.proxy, service: @bill_item.service, voice: @bill_item.voice }
    end

    assert_redirected_to bill_item_path(assigns(:bill_item))
  end

  test "should show bill_item" do
    get :show, id: @bill_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bill_item
    assert_response :success
  end

  test "should update bill_item" do
    patch :update, id: @bill_item, bill_item: { bill: @bill_item.bill, internet: @bill_item.internet, message: @bill_item.message, proxy: @bill_item.proxy, service: @bill_item.service, voice: @bill_item.voice }
    assert_redirected_to bill_item_path(assigns(:bill_item))
  end

  test "should destroy bill_item" do
    assert_difference('BillItem.count', -1) do
      delete :destroy, id: @bill_item
    end

    assert_redirected_to bill_items_path
  end
end
