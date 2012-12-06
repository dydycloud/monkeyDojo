class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :line_items, :dependent => :destroy

  # this method checks whether our list items already include the product we're adding
  #if product we buping the quantity / if not we adding a new LineItem
  def add_product(product_id)
  	current_item = line_items.where(:product_id => product_id).first
  	if current_item
  		current_item.quantity += 1
  	else
  		current_item = LineItem.new(:product_id => product_id)
  		line_items << current_item
  	end
  	current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def decrement_line_item(line_item_id)
    current_item = line_items.find(line_item_id)

    if current_item.quantity > 1
      current_item.quantity -= 1
    else
      current_item.destroy
    end
    current_item
  end

  def increment_line_item(line_item_id)
    current_item = line_items.find(line_item_id)

    if current_item.quantity > 0
      current_item.quantity += 1
    end
    current_item
  end
end
