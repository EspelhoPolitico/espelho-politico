class Proposicao < ActiveRecord::Base
  belongs_to :parlamentar
	
  validates :id, presence: true, length: {maximum: 11}
end
