class Proposicao < ActiveRecord::Base
  belongs_to :parlamentar
	
  validates :id, presence: true
	validates :id, length: {maximum: 11}
end

