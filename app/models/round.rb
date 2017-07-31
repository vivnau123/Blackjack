class Round < ApplicationRecord
  serialize :dealer_cards, Array
  belongs_to :game
end
