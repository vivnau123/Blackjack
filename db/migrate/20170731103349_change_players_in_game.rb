class ChangePlayersInGame < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :players, :text
  end
end
