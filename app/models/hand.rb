class Hand < ApplicationRecord
  serialize :cards, Array
  has_one :round
  belongs_to :user_game
end
