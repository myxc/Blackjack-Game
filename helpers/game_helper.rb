module GameHelper
  def save_state(deck)
    session[:deck_state] = deck
  end
  
  def load_deck
    session[:deck_state]
  end

  def sum(hand)
    sum = 0
    hand.each do |card|
      sum += card
    end
    return sum
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

  def save_bankroll(bank)
    session[:bankroll] = bank
  end

  def can_split
    if session[:split].nil? || !session[:split]
      return false
    else
      true
    end
  end

  def store_bet(bet)
    session[:bet] = bet
  end

  def load_bet
    session[:bet]
  end
  
  def win_bet(bet, blackjack = false)
    current = session[:bankroll]
    if blackjack
      bet *= 1.5
      current += bet
    else
      current += bet
    end
    session[:bankroll] = current
  end
  
  def check_overdraft
    if session[:overdraft].nil?
      session[:overdraft] = false
      return false
    else
      session[:overdraft]
    end
  end
  

    
end