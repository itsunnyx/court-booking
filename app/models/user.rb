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
class User < ApplicationRecord
  has_many :bookings
end
