class AddUserToUserGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_games, :user, foreign_key: true
  end
end
