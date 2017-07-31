class ChangeCardsInColumnsToBeText < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :cards, :text
    change_column :hands, :cards, :text
    change_column :rounds, :dealer_cards, :text
  end
end
