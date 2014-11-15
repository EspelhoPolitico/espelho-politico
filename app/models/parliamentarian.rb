class Parliamentarian < ActiveRecord::Base
  has_many :propositions
  validates :id, presence: true, length: {maximum: 11}
# :nocov:
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      take(600)
    end
  end
# :nocov:  
end
