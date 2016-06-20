require 'sinatra'
require './main.rb'

set :port, 8080
set :environment, :production

not_found do
  content_type :json
  status 404
  return '404!'
end

#Eventual routes
# /players => returns number of players in database * ?system=<system> will limit to system type
# /players/:battle-tag => returns all stats for player listed
# /players/:battle-tag/:hero => returns specific hero stats for player listed * ?stat=<statname> will return a specific single stat

get '/players' do
  content_type :json
  #return redisdatabase.keys limited by systemtype if requested
  return '{"error":"Please Specify ID or Hero"}'
end
get '/players/:id' do
  content_type :json
  bnet_id = BattleNetId.new(params[:id])
  if !bnet_id.in_database?
    bnet_id.crawl_stats
  end
  bnet_id.get_stats.to_json
end
get '/players/:id/:hero' do
  content_type :json
  bnet_id = BattleNetId.new(params[:id])
  puts bnet_id
  if !bnet_id.in_database?
    bnet_id.crawl_stats
  elsif !params[:stat].nil?
      return bnet_id.get_stats[params[:hero]][params[:stat]].to_json
  else
    return bnet_id.get_stats[params[:hero]].to_json
  end
end
