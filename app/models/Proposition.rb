class Proposition < ActiveRecord::Base
  belongs_to :Parliamentarian
	
  validates :id, presence: true, length: {maximum: 11}
end
