class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  
  protected

    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: "please log in"
      end
    end

  private
  	def current_cart
  		#finding the corresponding cart_id in the db
  		Cart.find(session[:cart_id])

  	#if the cart_id not exist we create an empty cart an put his id in session
  	rescue ActiveRecord::RecordNotFound
  		cart = Cart.create
  		session[:cart_id] = cart.id
  		cart
  	end
end
