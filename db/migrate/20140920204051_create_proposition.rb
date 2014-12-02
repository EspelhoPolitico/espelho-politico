class CreateProposition < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.string       :proposition_types
      t.integer      :number
      t.integer      :year
      t.date         :presentation_date
      t.text         :amendment
      t.text         :explanation
      t.string       :situation
      t.string       :content_link
      t.belongs_to   :parliamentarian
    end
    add_index(
      :propositions,
      [:proposition_types, :number, :year],
      unique: true
    )
  end
end
