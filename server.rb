require 'sinatra'
require './main.rb'
main = Main.new

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
  bnet_id = main::battle_net_id(params[:id])
  if !main.in_database?(bnet_id)
    main.crawl_stats(bnet_id)
  end
  main.get_stats(bnet_id).to_json
end

get '/stats/:id/:hero' do
  content_type :json
  bnet_id = main.battle_net_id(params[:id])
  puts bnet_id
  if !main.in_database?(bnet_id)
    main.crawl_stats(bnet_id)
  elsif !params[:stat].nil?
      return main.get_stats(bnet_id)[params[:hero]][params[:stat]].to_json
  else
    return main.get_stats(bnet_id)[params[:hero]].to_json
  end
end
