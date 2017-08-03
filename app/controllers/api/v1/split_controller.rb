module Api
  module V1
    class SplitController < ApplicationController
      def show
        if Hand.exists?(id: params[:id])
          hand = Hand.find(params[:id])
          if hand.status == 'ACTIVE' && isSplitAllowed(hand.cards)
            newHandCards = hand.cards.each_slice(1).to_a
            newHand = Hand.new(cards: newHandCards[1], coins: hand.coins/2, insurance: 0, payoff: 0, status: 'WAITING_NEXT', user_game_id: hand.user_game_id, round_id: hand.round_id)
            newHand.save
            hand.coins = hand.coins/2
            hand.cards = newHandCards[0]
            hand.save

            render json: {status: 'SUCCESS', message: 'Split completed, finish current hand followed by the next', current_hand: handOuput(hand), next_hand: handOuput(newHand)}, status: :ok
          else
          render json: {status: 'ERROR', message: 'Split not allowed!'}, status: :ok
          end
        else
          render json: {status: 'ERROR', message: 'Invalid hand id!'},status: :not_found
        end
      end


      private

      def isSplitAllowed(cards)
        if cards.length == 2
          if cards[0].to_i % 13 == cards[1].to_i % 13
            true
          else
            return false
          end
        else
          return false
        end
      end


    end
  end
end
