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
              hands_output<<handOuput(hand)
            end
            rounds_output<<roundOutput(round, hands_output)
          end
          render json: {
            game_id: game.id,
            decks: game.decks,
            game_status: game.status,
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
