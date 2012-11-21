require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  	test "should get index" do
	    get :index
	    assert_response :success
	    assert_select '#product_home', 3
	    assert_select 'h3', 'Welcome to the Dojo'
	    assert_select 'h4', 'Programing Ruby 1.9'
	end
end
