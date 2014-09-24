class Parlamentar < ActiveRecord::Base
  validates :id, presence: true
	validates :id, length: {maximum: 11}
end






