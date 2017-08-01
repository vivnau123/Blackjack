class AddCurrentRoundToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :current_round, :integer
  end
end
