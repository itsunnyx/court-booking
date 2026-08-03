require 'rails_helper'

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  credit     :integer          default(0)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
