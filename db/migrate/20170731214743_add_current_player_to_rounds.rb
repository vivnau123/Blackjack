class AddCurrentPlayerToRounds < ActiveRecord::Migration[5.1]
  def change
    add_column :rounds, :current_player, :integer
  end
end
