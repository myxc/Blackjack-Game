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
      if card == 1
        temp = sum + 11
        if temp <= 21
          sum += 11
          next
        else
          sum += 1
          next
        end
      else
        sum += card
      end
    end
    return sum
  end
  
  def save_player_hand(hand)
    session[:player] = hand
  end

  def load_player_hand
    session[:player]
  end
  
  def load_dealer_hand
    session[:dealer]
  end
  
  def doubled_down
    code = request.cookies["doubled"]
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
    current += bet
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
  
  def check_results(dealer, player) #returns 1 2 or 3 based on player win, lose or tie
    if dealer > 21
      return 1
    else
      if dealer > player
        return 2
      elsif dealer == player
        return 3
      else
        return 1
      end
    end
  end 
end