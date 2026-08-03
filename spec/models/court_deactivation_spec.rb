require 'rails_helper'

# == Schema Information
#
# Table name: court_deactivations
#
#  id         :bigint           not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  court_id   :bigint           not null
#
# Indexes
#
#  index_court_deactivations_on_court_id  (court_id)
#
# Foreign Keys
#
#  fk_rails_...  (court_id => courts.id)
#
RSpec.describe CourtDeactivation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
