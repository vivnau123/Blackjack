module Api
  module V1
    class GameStatusController < ApplicationController
      def show
        if Game.exists?(id: params[:id])
          game = Game.find(params[:id])
          @rounds = Round.where(:game_id => game.id)
          rounds_output = Array.new
          @rounds.each do |round|
            @hands = Hand.where(:round_id => round.id)
            hands_output = Array.new
            @hands.each do |hand|
              hand_output = {
                :id => hand.id,
                :cards => hand.cards.map{ |card| cardDetails(card)},
                :coins => hand.coins,
                :payoff => hand.payoff,
                :insurance => hand.insurance,
                :player => {
                  :name => User.find(UserGame.find(hand.user_game_id).user_id).name,
                  :user_id => User.find(UserGame.find(hand.user_game_id).user_id).id
                }
              }
              hands_output<<hand_output
            end
            round_output = {
              :id => round.id,
              :dealer_cards => round.dealer_cards.map{ |card| cardDetails(card)},
              :status => round.status,
              :current_player => {
                :name => User.find(round.current_player).name,
                :user_id => round.current_player
              },
              :hands => hands_output
            }
            rounds_output<<round_output
          end
          render json: {
            game_id: game.id,
            decks: game.decks,
            players: game.players.map{|id| {
              :name => User.find(id).name,
              :user_id => id
              }
            },
            rounds: rounds_output
          },status: :ok
        else
          render json: {status: 'ERROR', message: 'Invalid game id!'},status: :not_found
        end

      end
    end
  end
end
