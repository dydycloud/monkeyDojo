class Order < ActiveRecord::Base
  attr_accessible :address, :email, :name, :pay_type

  has_many :line_items, dependent: :destroy

  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]

  validates :name, :address, :email, presence: true
  #validate that the data for the payment type is part of the array we gives
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		#First we set the cart_id to nil in order 
		#to prevent the item from going poof when we destroy the cart.
  		item.cart_id = nil

  		#we add the item itself to the line_items collection for the order
  		line_items << item
  	end
  end
end
