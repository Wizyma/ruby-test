class PaymentsController < ApplicationController
  def create
    return head(:bad_request) unless valid_payment?
    emitter.update!(cash: emitter.cash - amount)
    receiver.update!(cash: receiver.cash + amount)
    head(:ok)
  end

  private

  def payment_params
    @payment_params ||=
      params.require(:payment).permit(:emitter_id, :receiver_id, :amount, :type)
  end

  def emitter
    @emitter ||= User.find(payment_params['emitter_id'])
  end

  def receiver
    @receiver ||= User.find(payment_params['receiver_id'])
  end

  def type
    payment_params['type']
  end

  def amount
    payment_params['amount'].to_i
  end

  def not_public_holiday_or_weekend?
    Holidays.on(Date.civil(DateTime.current.year, DateTime.current.month, DateTime.current.day), :fr).length == 0 && Date.today.on_weekday?
  end

  def valid_payment? 
    type && (amount <= 0 || payment_type_dictionnary[type])
  end

  def payment_type_dictionnary
    {
      "restaurant" => restaurant_valid_amount?,
      "others" => valid_amount? && not_public_holiday_or_weekend? == true
    }
  end

  def valid_amount?
    amount < (((4.3 * 4.3) + 0.51) * 100)
  end

  def restaurant_valid_amount?
    amount < (((4.3 * 4.3) + 0.51) * 100) * 2
  end
end
