$redis_pass = ARGV[0]
if $redis_pass.nil?
  abort('Usage: main.rb <Redis Password>')
end
require 'sinatra'
require './main.rb'

set :port, 8080
set :environment, :production

get '/get_stats' do
  content_type :json
  bnet_id = battle_net_id(params[:id])
  if params[:id].nil?
    return data_dump()
  end
  if get_stats(bnet_id).nil?
    crawl_stats(bnet_id)
  end
  get_stats(bnet_id).to_json
end

get '/get_stats/:hero' do
  content_type :json
  bnet_id = battle_net_id(params[:id])
  puts bnet_id
  if params[:id].nil?
    return 'No User Called'
  end

  if !in_database?(bnet_id)
    crawl_stats(bnet_id)
  elsif !params[:stat].nil?
      return get_stats(bnet_id)[params[:hero]][params[:stat]].to_json
  else
    return get_stats(bnet_id)[params[:hero]].to_json
  end
end
