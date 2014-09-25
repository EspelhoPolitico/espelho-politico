<<<<<<< HEAD
class Proposition < ActiveRecord::Base
  belongs_to :Parliamentarian
	
  validates :id, presence: true, length: {maximum: 11}
end
=======
class Proposicao < ActiveRecord::Base
  belongs_to :parlamentar
	
  validates :id, presence: true, length: {maximum: 11}
end
>>>>>>> 1e0dce01d676409e281880ac0f84fbe81cb526e3
