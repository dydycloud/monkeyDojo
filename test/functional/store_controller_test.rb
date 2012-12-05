require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  	test "should get index" do
	    get :index
	    assert_response :success
	    assert_select '#product_home', 3
	    assert_select 'h3', 'Welcome to the Dojo'
	    assert_select 'form'
	    assert_select '#price', /\$[,\d]+\.\d\d/

	end

	test "markup needed for store.js.coffee is in place" do 
		get :index
		assert_select '#product_home', minimum: 3
		assert_select '#entry input[type=submit]',3
		assert_select '#price', /\$[,\d]+\.\d\d/
	end
end
