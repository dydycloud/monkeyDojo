require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	test "the truth" do
		assert true
	end

	test "buying a product" do
		#By the end of the test, we know
		#we’ll want to have added an order to the orders table and a line item to the
		#line_items table, so let’s empty them out before we start. And, because we’ll be
		#using the Ruby book fixture data a lot, let’s load it into a local variable
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)

		#USER goes to the store indexpage.
		get "/"
		assert_response :success
		assert_template "index"

		#USER select a product, adding it to their cart. 
		#We know that our application uses an Ajax request to add things to the
		#cart, so we’ll use the xml_http_request() method to invoke the action. 
		xml_http_request :post, '/line_items', product_id: ruby_book.id
		assert_response :success

		#When it returns, we’ll check that the cart now contains the requested product:
		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		#USER check out
		get "/orders/new"
		assert_response :success
		assert_template "new"

		#At this point, the user has to fill in their details on the checkout form. Once
		#they do and they post the data, our application creates the order and redirects
		#to the index page. Let’s start with the HTTP side of the world by posting the
		#form data to the save_order action and verifying we’ve been redirected to the
		#index. We’ll also check that the cart is now empty. The test helper method
		#post_via_redirect() generates the post request and then follows any redirects
		#returned until a nonredirect response is returned.
		post_via_redirect "/orders",
						  order: { name:		"Dave Thomas",
								   address: 	"123 The Street",
								   email:		"dave@example.com",
								   pay_type: 	"Check" }
		assert_response :success
		assert_template "index"
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		#Next, we’ll wander into the database and make sure we’ve created an order
		#and corresponding line item and that the details they contain are correct.
		#Because we cleared out the orders table at the start of the test, we’ll simply
		#verify that it now contains just our new order

		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]
		assert_equal "Dave Thomas", 	 order.name
		assert_equal "123 The Street", 	 order.address
		assert_equal "dave@example.com", order.email
		assert_equal "Check",			 order.pay_type
		
		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product

		#Finally, we’ll verify that the mail itself is correctly addressed and has the
		#expected subject line
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Monkey Dojo <monkeydojo@example.com>', mail[:from].value
		assert_equal "Monkey Dojo Order Confirmation", mail.subject

	end
end
