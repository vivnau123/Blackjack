class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.integer :dealer_cards, array: true
      t.string :status

      t.timestamps
    end
  end
end
