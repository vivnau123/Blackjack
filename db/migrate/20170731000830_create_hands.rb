class CreateHands < ActiveRecord::Migration[5.1]
  def change
    create_table :hands do |t|
      t.integer :cards, array: true
      t.integer :coins
      t.integer :payoff
      t.string :status
      t.integer :insurance

      t.timestamps
    end
  end
end
