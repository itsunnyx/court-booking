# == Schema Information
#
# Table name: courts
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court < ApplicationRecord
end
