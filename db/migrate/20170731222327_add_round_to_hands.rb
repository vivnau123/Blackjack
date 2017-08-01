class AddRoundToHands < ActiveRecord::Migration[5.1]
  def change
    add_reference :hands, :round, foreign_key: true
  end
end
