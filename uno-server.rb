# Ruby Uno Server
require 'sinatra'
require 'json'

class UnoServer
  attr_reader :deck, :pool, :hands, :number_of_hands
  MAX_HANDS = 4
  def initialize
    @hands = Array.new
    @number_of_hands = 0
    @pool = Array.new
    @deck = %w(2-diamond 3-diamond 4-diamond 5-diamond 6-diamond 7-diamond 8-diamond 9-diamond 10-diamond)
    @deck.concat %w(2-heart 3-heart 4-heart 5-heart 6-heart 7-heart 8-heart 9-heart 10-heart)
    @deck.concat %w(2-club 3-club 4-club 5-club 6-club 7-club 8-club 9-club 10-club)
    @deck.concat %w(2-spade 3-spade 4-spade 5-spade 6-spade 7-spade 8-spade 9-spade 10-spade)
    @deck.concat %w(jack-diamond jack-heart jack-club jack-spade)
    @deck.concat %w(queen-diamond queen-heart queen-club queen-spade)
    @deck.concat %w(king-diamond king-heart king-club king-spade)
    @deck.concat %w(ace-diamond ace-heart ace-club ace-spade)
    @deck.concat %w(joker joker)
  end

  def join_game player_name
    return false unless @hands.size < MAX_HANDS
    player = {
        name: player_name,
        cards: []
    }
    @hands.push player
    true
  end

  def deal
    return false unless @hands.size > 0
    @pool = @deck.shuffle
    @hands.each {|player| player[:cards] = @pool.pop(5)}
    true
  end

  def get_cards player_name
    cards = 0
    @hands.each do |player|
      if player[:name] == player_name
        cards = player[:cards].dup
        break
      end
    end
    cards
  end

end

uno = UnoServer.new

###### Sinatra Part ######

set :port, 8080
set :environment, :production

get '/cards' do
  return_message = {}
  if params.has_key?('name')
    cards = uno.get_cards(params['name'])
    if cards.class == Array
      return_message[:status] == 'success'
      return_message[:cards] = cards
    else
      return_message[:status] = 'sorry - it appears you are not part of the game'
      return_message[:cards] = []
    end
  end
  return_message.to_json
end

post '/join' do
  return_message = {}
  jdata = JSON.parse(params[:data],:symbolize_names => true)
  if jdata.has_key?(:name) && uno.join_game(jdata[:name])
    return_message[:status] = 'welcome'
  else
    return_message[:status] = 'sorry - game not accepting new players'
  end
  return_message.to_json
end

post '/deal' do
  return_message = {}
  if uno.deal
    return_message[:status] = 'success'
  else
    return_message[:status] = 'fail'
  end
  return_message.to_json
end
