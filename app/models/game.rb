class Game < ApplicationRecord
  serialize :cards, Array
  serialize :players, Array
  has_many :user_games
  has_many :rounds
  has_many :users, :through => :user_games
end
