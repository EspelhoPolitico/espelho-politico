class Comment < ActiveRecord::Base
  acts_as_tree order: 'created_at DESC'

  validates_presence_of :author, :body, message: 'Campo obrigatório'   
  validates_length_of :body, :maximum => 800, :on => [:create], message: 'Formato inválido' 

end
