class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

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
