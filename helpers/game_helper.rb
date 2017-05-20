module GameHelper
  def save_state(deck)
    session[:deck_state] = deck
  end
  
  def load_deck
    session[:deck_state]
  end

  def sum(hand)
    sum = 0
    hand.size do |card|
      sum += card
    end
    sum
  end
  
  def save_player_hand(hand)
    session[:player] = hand
  end
  
  def save_dealer_hand(hand)
    session[:dealer] = hand
  end

  def check_bankroll
    if session[:bankroll].nil?
      session[:bankroll] = 1000
    else
      session[:bankroll]
    end
  end  

  
end