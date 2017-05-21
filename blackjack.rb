require 'sinatra'
require './blackjack/deck.rb'
require 'pry-byebug'
require './helpers/game_helper.rb'

# Stay: turn moves to dealer
# Hit: Player gets another card, busts if total >21
# Doubling: Player doubles his bet, gets 1 card
# Split: Only if player gets 2 cards that are identical
# If player at any point gets > 21 he busts and loses that hand and his wager
#5. Dealer always hits until he has 17 or more points or busts
#6. After dealer finishes his turn (hits to >17 or busts) bets are paid 1:1
#7. Players who've tied dealer are returned their bet.
#8 check if player hit blackjack right off the bat, and if he did, pay out 3:2

#Cookies: simple key-value pairs read using request.cookies["cookie_name"], written using response.cookies("cookie_name","cookie_value")
helpers GameHelper
enable :sessions
#sessions: hash that sticks around between requests.

#params: read only hash of stuff browser sent to server (stuff in query string) in key-value pairs.
#helpers: modules filled iwth methods used in both views and main applications. require './root/folder/helper.rb' to use. Then register the module by instantiating the class via "helpers ModuleName"

#use erb tags only to display stuff you need, don't put any heavy logic into it (it's hard to)

get '/' do 
  nino_number = rand(9999)
  erb :homepage, locals: {table: nino_number}
end

get '/blackjack/bet' do
  bankroll = check_bankroll
  erb :bet, locals: {bankroll: bankroll}
end

post '/blackjack/submit_bet' do
  bet = params["wager"].to_i
  bankroll = check_bankroll
  if bet <= bankroll
    bankroll -= bet
    store_bet(bet)
    save_bankroll(bankroll)
    redirect to("/blackjack") 
  else
    session[:overdraft] = true
    erb :bet, locals: {bankroll: bankroll}
  end
end
 
get '/blackjack' do
  deck = Deck.new #deck is created and shuffled right when deck is instantiated.
  player_hand = deck.deal_player
  dealer_hand = deck.deal_dealer
  player = [player_hand[0][1], player_hand[1][1]]
  dealer = [dealer_hand[0][1], dealer_hand[1][1]]
  save_state(deck)
  save_player_hand(player)
  save_dealer_hand(dealer)

  player_sum = sum(player)
  dealer_sum = sum(dealer)

  player_bankroll = check_bankroll
  if player[0] == player[1]
    session[:split] = true
  else
    session[:split] = false
  end
  bet = load_bet
  if player_sum == 21
    result = 4
    win_bet(bet, true)
    response.set_cookie("result", result)    
    erb :results, locals: {player_sum: player_sum, dealer_sum: dealer_sum}
  end
  erb :blackjack, locals: {player: player, dealer: dealer, player_sum: player_sum, dealer_sum: dealer_sum}  
end

get '/blackjack/hit' do
  deck = load_deck
  #load pertinent elements: player cards, player sum dealer sum and check for splits:
  player_hand = load_player_hand
  dealt_card = deck.state.pop
  card = dealt_card[1]
  player_hand << card
  player_sum = sum(player_hand)
  save_player_hand(player_hand)
  save_state(deck)

  dealer = load_dealer_hand
  dealer_sum = sum(dealer)

  session[:split] = false
  temp = player_hand.size
  player_hand.each_with_index do |card, index|
    0.upto(temp) do |cmp|
      if cmp != index
        if card == player_hand[cmp]
          session[:split] = true
        else
          next
        end
      end
    end
  end

  if player_sum < 21
    erb :blackjack, locals: {player: player_hand, dealer: dealer, player_sum: player_sum, dealer_sum: dealer_sum}  
  elsif player_sum == 21
    redirect to"/blackjack/dealer"
  else
    redirect to"/blackjack/bust"
  end
end

get '/blackjack/stay' do
  redirect to"blackjack/dealer"
end

get '/blackjack/double' do
  bet_amount = load_bet
  bankroll = check_bankroll
  if bet_amount <= bankroll
    bankroll -= bet_amount
    store_bet(bet_amount * 2)
    save_bankroll(bankroll)
    response.set_cookie("doubled", 1)
    redirect to("/blackjack/dealer") 
  else
    player = load_player_hand
    player_sum = sum(player)
    dealer = load_dealer_hand
    dealer_sum = sum(dealer)
    response.set_cookie("doubled", 2)
    erb :blackjack, locals: {player: player, dealer: dealer, player_sum: player_sum, dealer_sum: dealer_sum}  
  end
end

get '/blackjack/split' do
  "this is splitting"
end

get '/blackjack/dealer' do
  #dealer hits until 
  player = load_player_hand
  player_sum = sum(player)
  dealer = load_dealer_hand
  dealer_sum = sum(dealer)  
  n_deck = load_deck
  while dealer_sum < 17
    dealt_card = n_deck.state.pop  
    card = dealt_card[1]
    dealer << card
    dealer_sum = sum(dealer)
  end
  save_state(n_deck)
  save_dealer_hand(dealer)
  bet = load_bet
  result = check_results(dealer_sum, player_sum) #returns a 1 2 3 based on player result
  if result == 1
    win_bet(bet)
  # elsif result == 2
  #   redirect to"/blackjack/bust"    
  elsif result == 3
    temp = check_bankroll
    temp += bet
    save_bankroll(temp)
  end
  response.set_cookie("result", result)
  binding.pry
  erb :results, locals: {player_sum: player_sum, dealer_sum: dealer_sum}
end