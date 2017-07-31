class Game < ApplicationRecord::Base
  has_many :user_games
  has_many :rounds
  has_many :users, :through => :user_games
end
