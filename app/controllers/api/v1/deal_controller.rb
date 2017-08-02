module Api
  module V1
    class DealController < ApplicationController
      def create
        if Game.exists?(id: deal_params[:id])
          game = Game.find(deal_params[:id])
          if game.status == 'INITIALIZED'
            cards = game.cards
            number_of_cards = cards.length
            players = game.players
            number_of_players = players.length

            i = rand(number_of_cards)
            j = rand(number_of_cards - 1)
            number_of_cards = number_of_cards-2

            card_i = cards[i]
            cards.delete(card_i)
            card_j = cards[j]
            cards.delete(card_j)

            status = 'ACTIVE'

            if card_i % 13 == 1
              status = 'INSURANCE'
            end
            dealer_cards = Array.new([card_i, card_j])
            round = Round.new(current_player: players[0], status: status, dealer_cards: dealer_cards, game_id: game.id)
            round.save

            hands = Array.new
            k = 0
            x = 0
            players.each do |player_id|
              userGame = UserGame.find_by user_id: player_id, game_id: game.id

              i = rand(number_of_cards)
              j = rand(number_of_cards - 1)
              number_of_cards = number_of_cards-2

              card_i = cards[i]
              cards.delete(card_i)
              card_j = cards[j]
              cards.delete(card_j)

              hand_status = (status == 'INSURANCE') ? status : ((x==0)? 'ACTIVE' : 'WAITING')
              user_cards = Array.new([card_i, card_j])

              payoff = 0

              coins = deal_params[:coins]

              if handValue(user_cards) == 21
                hand_status = 'WINNER'
                payoff = coins[k]*1.5
              else
                x = 1
              end

              hand = Hand.new(coins: (coins[k] + payoff), payoff: payoff, insurance: 0, user_game_id: userGame.id, status: hand_status, cards: user_cards, round_id: round.id)
              hand.save
              hands<<{player: User.find(player_id).name,user_id: player_id,status: hand_status,coins: (coins[k] + payoff), payoff: payoff, cards_value: handValue(user_cards), id: hand.id, user_id: player_id, cards: user_cards.map{|card| cardDetails(card)}}
              k = k + 1
            end

            game.cards = cards
            game.status = 'ROUND_UNDERWAY'
            game.current_round = round.id
            game.save
            round.dealer_cards.delete(round.dealer_cards[1])
            round.dealer_cards = round.dealer_cards.map{ |card| cardDetails(card)}

            render json: {hands: hands, round: round.attributes.except("created_at","updated_at")}

          elsif game.status == 'ROUND_UNDERWAY'
            currentRound = Round.find(game.current_round)
            currentPlayer = User.find(currentRound.current_player).name
            render json: {status: 'ERROR', message: "Dealing done, betting underway, It's "+ currentPlayer +"'s turn"}, status: :unprocessable_entry
          else
            render json: {status: 'ERROR', message: "Game invalid"}, status: :unprocessable_entry
          end
        else
          render json: {status: 'ERROR', message: 'game id does not exist'}, status: :not_found
        end
      end

      private

      def deal_params
        params.permit(:id, :coins => []);
      end

    end
  end
end
