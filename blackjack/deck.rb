class Deck
  def initialize
    suits=[1,2,3,4]
    card_values=[1,2,3,4,5,6,7,8,9,10,10,10,10] #1 is ace, 10's are 10 and face cards
    @deck = suits.product(card_values)
    @deck.shuffle!
  end

  def state
    @deck
  end
  
  def deal_player
    hand = [@deck.pop, @deck.pop]
  end
  
  def deal_dealer
    hand = [@deck.pop, @deck.pop]
  end
end


    


