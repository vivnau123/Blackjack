class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :decks
      t.integer :players
      t.integer :cards, array: true

      t.timestamps
    end
  end
end
