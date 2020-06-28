require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "#create requirement payment parameter" do
    assert_raises(ActionController::ParameterMissing) do
      post payments_url, params: { payment: {} }
    end
  end

  test "#create require existing users" do
    assert_raises(ActiveRecord::RecordNotFound) do
      post payments_url, params:
        { payment: { emitter_id: 123, receiver_id: 456, amount: 120, type: 'restaurant' } }
    end
  end

  test "#create require amount less than 19 euros" do
    travel_to Date.civil(2020, 6, 25)
    User.create!(id: 123, email: 'first@test.com')
    User.create!(id: 456, email: 'second@test.com')
    post payments_url, params:
      { payment: { emitter_id: 123, receiver_id: 456, amount: 2000, type: 'others' } }
    assert_response :bad_request
  end

  test "#create require to be on public holiday" do
    travel_to Date.civil(2020, 4, 13)
    User.create!(id: 123, email: 'first@test.com')
    User.create!(id: 456, email: 'second@test.com')
    post payments_url, params:
      { payment: { emitter_id: 123, receiver_id: 456, amount: 1800, type: 'others'  } }
    assert_response :bad_request
  end

  test "#create require to be on public holiday for restaurant" do
    travel_to Date.civil(2020, 4, 13)
    User.create!(id: 123, email: 'first@test.com')
    User.create!(id: 456, email: 'second@test.com')
    post payments_url, params:
      { payment: { emitter_id: 123, receiver_id: 456, amount: 1800, type: 'restaurant'  } }
    assert_response :ok
  end

  test "#create modify the cash balance of concerned users" do
    User.create!(id: 123, email: 'first@test.com', cash: 10000)
    User.create!(id: 456, email: 'second@test.com', cash: 10000)
    post payments_url, params:
      { payment: { emitter_id: 123, receiver_id: 456, amount: 1800, type: 'restaurant'  } }
    assert_response :ok
    assert User.find(123).cash == 8200
    assert User.find(456).cash == 11800
  end
end
