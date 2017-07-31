class Hand < ApplicationRecord
  has_one :round
  belongs_to :user_game
end
