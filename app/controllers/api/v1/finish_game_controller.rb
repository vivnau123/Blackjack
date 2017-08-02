module Api
  module V1
    class FinishGameController < ApplicationController
      def show
        if Game.exists?(id: params[:id])
          game = Game.find(params[:id])
          game.status = 'FINISHED'
          game.save
          @rounds = Round.where(:game_id => game.id)

          @rounds.each do |round|
            @hands = Hand.where(:round_id => round.id)
            @hands.each do |hand|
              hand.status = 'FINISHED'
              hand.save
            end
            round.status = 'FINISHED'
            round.save
          end
          render json: {status: 'SUCCESS', message: 'Game finished successfully'},status: :ok
        else
          render json: {status: 'ERROR', message: 'Invalid game id!'},status: :not_found
        end
      end
    end
  end
end
