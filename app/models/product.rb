class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  has_many :line_items
  has_many :orders, through: :line_items

  #here we prevent any deleting action for a product whitch can be in a cart
  before_destroy :ensure_not_referenced_by_any_line_item

  #ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      error[:base] << "Line Items present"
      return false
    end
  end
  
  #settind a default scope to classify a request to db order by title
  default_scope :order => 'title'

  #validates that the following fields have some date in them
  validates :title, :description, :image_url, :presence => true

  #validates that the price is a positive number
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}

  #validates that the title is unique
  validates :title, :uniqueness => true

  #validates format for product's image
  validates :image_url, :format => {
  	:with => %r{\.(gif|jpg|png)$}i,
  	:message => 'must be a url for GIF, PNG, JPG image.'
  }

end
