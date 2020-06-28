require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "cash default validation" do
    assert User.new.cash == 0
  end

   test "email validation" do
     refute User.new(email: nil).valid?
     refute User.new(email: '').valid?
     assert User.new(email: 'a@b.c').valid?
   end
end
