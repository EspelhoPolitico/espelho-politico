class PropositionTheme < ActiveRecord::Base
  belongs_to :Proposition
  belongs_to :Theme         
end