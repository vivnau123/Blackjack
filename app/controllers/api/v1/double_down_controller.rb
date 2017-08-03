module Api
  module V1
    class DoubleDownController < ApplicationController
      def show
        if Hand.exists?(id: params[:id])
          hand = Hand.find(params[:id])
          if hand.status == 'ACTIVE' && isDoubleDownAllowed(hand.cards)
            hand.coins = hand.coins*2

            game = Game.find(UserGame.find(hand.user_game_id).game_id)
            gameCards = game.cards
            handCards = hand.cards

            i = rand(gameCards.length)
            card_i = gameCards[i]

            handCards << card_i
            gameCards.delete(card_i)

            value = handValue(handCards)

            hand.status = (value > 21) ? 'BUST' : 'FINISHED'
            hand.cards = handCards
            hand.save

            game.cards = gameCards
            game.save

            @hands = Hand.where("round_id = ? AND status = ?", hand.round_id, 'WAITING_NEXT').order('created_at ASC')
            if @hands.length > 0
              nextHand = @hands[0]
              nextHand.status = 'ACTIVE'
              nextHand.save
            else
              @hands = Hand.where("round_id = ? AND status = ?", hand.round_id, 'WAITING').order('created_at ASC')
            end
            if @hands.length > 0
              nextHand = @hands[0]
              nextHand.status = 'ACTIVE'
              nextHand.save
            else
              revealDealerCards(hand.round_id)
            end

            cardDetails = hand.cards.map{ |card| cardDetails(card)}
            render json: { status:'FINISHED', message:'Wait for the dealer to reveal his cards', cards: cardDetails, value: value },status: :ok
          else
            render json: {status: 'ERROR', message: 'Double down not allowed!'}, status: :ok
          end
        else
          render json: {status: 'ERROR', message: 'Invalid hand id!'},status: :not_found
        end
      end

      def isDoubleDownAllowed(cards)
        if cards.length == 2
          total = 0
          cards.each do |card|
            card.to_i
            card = card % 13
            if card > 10 || card == 0
              card = 10
            end
            total += card
          end
          if total >= 9 && total <= 11
            return true
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
