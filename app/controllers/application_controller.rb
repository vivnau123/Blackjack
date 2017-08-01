class ApplicationController < ActionController::Base
  def cardDetails(cardNumber)
    denominations = [1,2,3,4,5,6,7,8,9,10,'Jack','Queen','King']
    cardNumber = cardNumber % 52
    denomination = denominations[(cardNumber % 13 - 1)]
    suits = ['Diamonds','Clubs','Hearts','Spades']
    suit = suits[(cardNumber/13).to_i]
    return denomination.to_s + " of " + suit
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
    possibilities = Array.new([total - 21])
    
    aces.times do |i|
      possibilities.push(total + (i+1)*10 - 21)
    end

    total = possibilities.select{|n| n <= 0}.max + 21
    return total
  end
end
