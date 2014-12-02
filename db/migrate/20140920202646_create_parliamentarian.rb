class CreateParliamentarian < ActiveRecord::Migration
  def change
    create_table :parliamentarians do |t|
      t.string  :condition
      t.string  :registry
      t.string  :civil_name
      t.string  :name
      t.string  :url_photo
      t.string  :state
      t.string  :party
      t.integer :cabinet
      t.string  :phone
      t.string  :email
    end
    add_index :parliamentarians, :name
    add_index :parliamentarians, :registry
  end
end
