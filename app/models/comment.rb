class Comment < ActiveRecord::Base
  acts_as_tree order: 'created_at DESC'
  validates_presence_of :title, :author, :body, message: 'Campo obrigatório'
  VALID_TITLE_REGEX = /[a-z0-9._-]{5,30}/i
  validates_format_of :title, with: VALID_TITLE_REGEX, :on => [:create], message: 'Formato inválido'
  VALID_AUTHOR_REGEX = /[a-z0-9._-]{3,30}/i
  validates_format_of :author, with: VALID_AUTHOR_REGEX, :on => [:create], message: 'Formato inválido'
  validates_length_of :body, :maximum => 140, :on => [:create], message: 'Formato inválido'
end