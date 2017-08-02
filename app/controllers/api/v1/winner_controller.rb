module Api
  module V1
    class WinnerController < ApplicationController
      def show
        if Game.exists?(id: params[:id])
          game = Game.find(params[:id])
          @rounds = Round.where(:game_id => game.id).order('created_at DESC')
          winners = Array.new
          i = 0
          @rounds.each do |round|
            @hands = Hand.where(:round_id => round.id)
            handWinners = Array.new
            @hands.each do |hand|
              if hand.status == 'WINNER'
                handWinner = {
                  :player => {
                    :name => User.find(UserGame.find(hand.user_game_id).user_id).name,
                    :user_id => User.find(UserGame.find(hand.user_game_id).user_id).id
                  },
                  :coins => hand.coins,
                  :payoff => hand.payoff

                }
                handWinners<<handWinner
              end
            end
            roundWinners = {
              :round => i,
              :winners => handWinners
            }
            winners<<roundWinners
            i = i + 1
          end
          render json: {winners_by_round: winners}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Invalid game id!'},status: :not_found
        end
      end
    end
  end
end
