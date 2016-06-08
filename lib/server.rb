require 'sinatra'
require './main.rb'

set :port, 8080
set :environment, :production

not_found do
  content_type :json
  status 404
  return '404!'
end

get '/stats' do
  content_type :json
  return '{"error":"Please Specify ID or Hero"}'
end

get '/stats/:id' do
  content_type :json
  bnet_id = battle_net_id(params[:id])
  if !in_database?(bnet_id)
    crawl_stats(bnet_id)
  end
  get_stats(bnet_id).to_json
end

get '/stats/:id/:hero' do
  content_type :json
  bnet_id = battle_net_id(params[:id])
  puts bnet_id
  if !in_database?(bnet_id)
    crawl_stats(bnet_id)
  elsif !params[:stat].nil?
      return get_stats(bnet_id)[params[:hero]][params[:stat]].to_json
  else
    return get_stats(bnet_id)[params[:hero]].to_json
  end
end
