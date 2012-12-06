require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
    mail = OrderNotifier.received(orders(:one))
    assert_equal "Monkey Dojo Order Confirmation", mail.subject
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Monkey Dojo Order Shipped", mail.subject
  end

end
