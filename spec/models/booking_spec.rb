require 'rails_helper'

# == Schema Information
#
# Table name: bookings
#
#  id                       :bigint           not null, primary key
#  time                     :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  court_id                 :bigint           not null
#  stripe_payment_intent_id :string
#  user_id                  :bigint           not null
#
# Indexes
#
#  index_bookings_on_court_id  (court_id)
#  index_bookings_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (court_id => courts.id)
#  fk_rails_...  (user_id => users.id)
#
RSpec.describe Booking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
