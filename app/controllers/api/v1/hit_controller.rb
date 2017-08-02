module Api
  module V1
    class HitController < ApplicationController
      def show
        if Hand.exists?(id: params[:id])
          hand = Hand.find(params[:id])
        if hand.status == 'ACTIVE'
            cards = hand.cards
            userGame = UserGame.find(hand.user_game_id)
            player = User.find(userGame.user_id)
            game = Game.find(userGame.game_id)
            gameCards = game.cards

            i = rand(gameCards.length)
            card_i = gameCards[i]
            gameCards.delete(card_i)
            game.cards = gameCards

            if gameCards.length == 0
              game.status = 'FINISHED'
              game.save
            end

            game.save

            cards<<card_i
            value = handValue(cards)
            status = (value == 21) ? 'FINISHED' : ((value > 21) ? 'BUST' : 'ACTIVE')

            hand.cards = cards
            hand.status = status
            hand.save

            if(value >= 21)
              @hands = Hand.where("round_id = ? AND status = ?", hand.round_id, 'WAITING').order('created_at ASC')
              if @hands.length > 0
                nextHand = @hands[0]
                nextHand.status = 'ACTIVE'
                nextHand.save
              else
                revealDealerCards(hand.round_id)
              end
            end

            cardDetails = cards.map{ |card| cardDetails(card)}

            case status
              when 'FINISHED'
                render json: { status:'FINISHED', message:'You got a 21, wait for the dealer to reveal his cards!', cards: cardDetails, value: value },status: :ok
              when 'BUST'
                render json: { status:'BUST', message:'You got bust, best of the luck for the next hand!', cards: cardDetails, value: value },status: :ok
              when 'ACTIVE'
                render json: { status:'ACTIVE', message:'What do you want to do: hit again or stand?', cards: cardDetails, value: value },status: :ok
            end
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
