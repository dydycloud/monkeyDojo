require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:image_url].any?
  	assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new( :title		=> "Book title",
    					   :description	=> "Lorem",
    					   :image_url	=> 'lorem.gif'
    					 )
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
  	Product.new(:title			=> "Book One",
  				:description	=> "Lorem",
  				:price			=> 1,
  				:image_url		=> image_url
  				)
  end

  test "image url" do
    	#Here rather than write nine test we gonna use 2 loops

    	#set up two variables
    	#one with the good type of image file
    	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.C/x/y/z/fred.gif }

    	#one with the bad type of image file
    	bad = %w{ fred.doc fred.gif/more fred.gif.more }

    	#first loop to test good case
    	ok.each do |name|
    		assert new_product(name).valid?, "#{name} shouldn't be invalid"
    	end

    	#second loop to test bad case
    	bad.each do |name|
    		assert new_product(name).invalid?, "#{name} shouldn't be invalid"
    	end
  end

  test "product is not valid without a unique title" do
    	product = Product.new(:title => products(:ruby).title,
  					:description	=> "Lorem",
  					:price			=> 1,
  					:image_url		=> "fred.png"
  				   )

    	assert !product.save
    	assert_equal "has already been taken", product.errors[:title].join("; ")
  end
end
