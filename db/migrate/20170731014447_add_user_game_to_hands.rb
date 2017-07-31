class AddUserGameToHands < ActiveRecord::Migration[5.1]
  def change
    add_reference :hands, :user_game, foreign_key: true
  end
end
