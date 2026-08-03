class UsersController < ApplicationController
  def add_credit
    amount = params[:amount].to_i
    if amount > 0
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'thb',
            product_data: {
              name: 'Court Booking Credits',
            },
            unit_amount: amount * 100,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: payment_success_users_url + "?amount=#{amount}",
        cancel_url: root_url,
      })

      redirect_to session.url, allow_other_host: true
    else
      redirect_to root_path, alert: "Invalid amount."
    end
  end

  def payment_success
    amount = params[:amount].to_i
    if amount > 0
      current_user.update!(credit: current_user.credit + amount)
      redirect_to root_path, notice: "#{amount} credits successfully added via Stripe!"
    else
      redirect_to root_path, alert: "Payment succeeded but invalid amount returned."
    end
  end
end
