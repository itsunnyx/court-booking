class AddStripeToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :stripe_payment_intent_id, :string
  end
end
