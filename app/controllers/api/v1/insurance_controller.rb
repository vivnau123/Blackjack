module Api
  module V1
    class InsuranceController < ApplicationController
      def create
        if Round.exists?(id: insurance_params[:round_id])
          round = Round.find(insurance_params[:round_id])
          currentPlayer = User.find(round.current_player).name
          if round.status == 'INSURANCE'
            insuranceList = insurance_params[:insurance]
            i = 0
            hands = []
            insuranceList.each do |insuranceObj|
              handId = insuranceObj[:hand_id]
              insurance = insuranceObj[:insurance]
              if Hand.exists?(id: handId)
                hand = Hand.find(handId)
                if hand.status == 'INSURANCE' && hand.round_id == round.id && hand.coins >= 2*insurance
                  userGame = UserGame.find(hand.user_game_id)
                  hand.insurance = insurance
                  hand.status = (userGame.user_id == round.current_player)? 'ACTIVE' : 'WAITING'
                  if hand.save
                    i = i+1
                    hands<<{player: User.find(userGame.user_id).name, user_id: userGame.user_id,status: hand.status,coins: hand.coins, payoff: hand.payoff, insurance:hand.insurance, cards_value: handValue(hand.cards), id: hand.id, cards: hand.cards.map{|card| cardDetails(card)}}
                  else
                    break
                  end
                else
                  break
                end
              else
                break
              end
            end
            if i == insuranceList.length
              round.status = 'ACTIVE'
              round.save
              round.dealer_cards = round.dealer_cards.map{ |card| cardDetails(card)}
              render json: {hands: hands,round:round.attributes.except("created_at","updated_at"),message: "Insurance placed, move to playing hands. It's "+ currentPlayer +"'s turn"}
            else
              render json: {status: 'ERROR', message: 'Invalid inputs'}
            end
          elsif round.status == 'ACTIVE'
            render json: {status: 'ERROR', message: "No insurance!! It's "+ currentPlayer +"'s turn"}, status: :unprocessable_entry
          else
            render json: {status: 'ERROR', message: "Game invalid"}, status: :unprocessable_entry
          end
        else
          render json: {status: 'ERROR', message: 'game id does not exist'}, status: :not_found
        end
      end
      private

      def insurance_params
        params.permit(:round_id, :insurance => [:hand_id, :insurance]);
      end
    end
  end
end
