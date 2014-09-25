class CriarProposicao < ActiveRecord::Migration
  def change
		create_table	:tipo_proposicao do |t|
			t.string		:sigla      
			t.string		:descricao
		end
	end
end
