class AddGameToUserGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_games, :game, foreign_key: true
  end
end
