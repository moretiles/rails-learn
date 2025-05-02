require "test_helper"

class ProductMailerTest < ActionMailer::TestCase
  test "in_stock" do
    mail = ProductMailer.with(product: products(:tshirt), subscriber: subscribers(:brian)).in_stock
    # assert_equal "In Stock", mail.subject.to_s
    assert_equal [ "brian@mail.home.arpa" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    # assert_match "Good news!", mail.body.encoded
  end
end
