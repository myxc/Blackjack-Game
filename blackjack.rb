require 'sinatra'
require './blackjack/deck.rb'
require 'pry-byebug'
require './helpers/game_helper.rb'

#goal to get more points than dealer without going over 21.
#1. player bets
#2.Player and dealer dealt two cards, dealer's second card is facedown
# If dealer his 21 points total (blackjack), everyone loses unless a player also gets 21, in which case it's a tie
# 3. If player gets 21 and dealer doesn't have 21, he hits blackjack and gets paid 3:2 (Can only get blackjack on newly split hand or initial deal)
# 4. Player begins his turn: Hitting, staying, doubling, or splitting
# Stay: turn moves to dealer
# Hit: Player gets another card, busts if total >21
# Doubling: Player doubles his bet, gets 1 card
# Split: Only if player gets 2 cards that are identical
# If player at any point gets > 21 he busts and loses that hand and his wager
#5. Dealer always hits until he has 17 or more points or busts
#6. After dealer finishes his turn (hits to >17 or busts) bets are paid 1:1
#7. Players who've tied dealer are returned their bet.
#8. POINTS:
#9. Aces are 1 or 11, depending on which value gives player a higher # or prevents a bust., other cards are worth their face value, face cards are worth 10.

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
    split = true
  else
    split = false
  end
  
  erb :blackjack, locals: {player: player, dealer: dealer, player_sum: player_sum, :dealer_sum dealer_sum, bankroll: player_bankroll, split: split}  
end







