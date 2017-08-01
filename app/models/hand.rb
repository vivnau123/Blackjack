class Hand < ApplicationRecord
  serialize :cards, Array
  belongs_to :round
  belongs_to :user_game
end
