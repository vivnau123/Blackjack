module Api
  module V1
    class StandController < ApplicationController
      def show
        if Hand.exists?(id: params[:id])
          hand = Hand.find(params[:id])
          if hand.status == 'ACTIVE'
            hand.status = 'FINISHED'
            hand.save
            @hands = Hand.where("round_id = ? AND status = ?", hand.round_id, 'WAITING').order('created_at ASC')
            if @hands.length > 0
              nextHand = @hands[0]
              nextHand.status = 'ACTIVE'
              nextHand.save
            else
              revealDealerCards(hand.round_id)
            end
            cardDetails = hand.cards.map{ |card| cardDetails(card)}
            value = handValue(hand.cards)
            render json: { status:'FINISHED', message:'Wait for the dealer to reveal his cards', cards: cardDetails, value: value },status: :ok
          else
            render json: {status: 'ERROR', message: 'Your hand is not active, you will have to wait'}, status: :ok
          end
        else
          render json: {status: 'ERROR', message: 'Invalid hand id!'},status: :not_found
        end
      end
    end
  end
end
