class ApplicationController < ActionController::Base
  def cardDetails(cardNumber)
    denominations = [1,2,3,4,5,6,7,8,9,10,'Jack','Queen','King']
    cardNumber = cardNumber % 52
    denomination = denominations[(cardNumber % 13 - 1)]
    suits = ['Diamonds','Clubs','Hearts','Spades']
    suit = suits[(cardNumber/13).to_i]
    return denomination.to_s + " of " + suit
  end

  def roundOutput(round, hands_output)
    return {
      :id => round.id,
      :dealer_cards => round.dealer_cards.map{ |card| cardDetails(card)},
      :status => round.status,
      :current_player => {
        :name => User.find(round.current_player).name,
        :user_id => round.current_player
      },
      :hands => hands_output
    }
  end

  def handOuput(hand)
    return {
      :id => hand.id,
      :cards => hand.cards.map{ |card| cardDetails(card)},
      :coins => hand.coins,
      :payoff => hand.payoff,
      :insurance => hand.insurance,
      :status => hand.status,
      :player => {
        :name => User.find(UserGame.find(hand.user_game_id).user_id).name,
        :user_id => User.find(UserGame.find(hand.user_game_id).user_id).id
      }
    }
  end

  def handValueDealer(userCards)
    total = 0
    aces = 0
    userCards.each do |userCard|
      userCard.to_i
      userCard = userCard % 13
      if userCard > 10 || userCard == 0
        userCard = 10
      end
      if userCard == 1
        aces += 1
      end
      total += userCard
    end
    possibilities = Array.new([total])

    aces.times do |i|
      possibilities.push(total + (i+1)*10)
    end

    maximum = possibilities.select{|n| n <= 16}.max

    total =  (maximum) ? maximum : total
    return total
  end

  def handValue(userCards)
    total = 0
    aces = 0
    userCards.each do |userCard|
      userCard.to_i
      userCard = userCard % 13
      if userCard > 10 || userCard == 0
        userCard = 10
      end
      if userCard == 1
        aces += 1
      end
      total += userCard
    end
    possibilities = Array.new([total])

    aces.times do |i|
      possibilities.push(total + (i+1)*10)
    end

    maximum = possibilities.select{|n| n <= 21}.max

    total =  (maximum) ? maximum : total
    return total
  end

  def revealDealerCards(roundId)
    round = Round.find(roundId)
    dealerCards = round.dealer_cards
    game = Game.find(round.game_id)
    gameCards = game.cards

    i = rand(gameCards.length)
    card_i = gameCards[i]

    while handValueDealer(dealerCards) <= 16
      dealerCards<<card_i
      gameCards.delete(card_i)
      i = rand(gameCards.length)
      card_i = gameCards[i]
    end

    game.cards = gameCards
    round.dealer_cards = dealerCards
    round.status = 'FINISHED'
    game.status = 'INITIALIZED'
    game.save
    round.save

    dealerValue = handValue(dealerCards)

    @hands = Hand.where(:round_id => roundId)

    @hands.each do |hand|
      player = User.find(UserGame.find(hand.user_game_id).user_id)
      if((hand.status == 'FINISHED') && (dealerValue > 21 || handValue(hand.cards) > dealerValue))
        hand.status = 'WINNER'
        hand.payoff = hand.coins
        player.coins += hand.payoff
        hand.save
        player.save
      elsif((hand.status == 'FINISHED') && (handValue(hand.cards) == dealerValue))
        hand.status = 'PUSH'
        hand.save
      else
        hand.status = 'BUST'
        player.coins -= hand.coins
        hand.save
        player.save
      end
    end

  end
end
