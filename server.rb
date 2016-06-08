$redis_pass = ARGV[0]
if $redis_pass.nil?
  abort('Usage: main.rb <Redis Password>')
end
require 'sinatra'
require './main.rb'

set :port, 8080
set :environment, :production

# 404 Error!
not_found do
  status 404
  return '404!'
end

get '/stats' do
  return 'Please Specify ID or Hero'
end

get '/stats/:id' do
  content_type :json
  if in_database?(params[:id].gsub('-','#'))
    bnet_id = params[:id].gsub('-','#')
  else
    bnet_id = battle_net_id(params[:id])
  end
  if !in_database?(bnet_id)
    crawl_stats(bnet_id)
  end
  get_stats(bnet_id).to_json
end

get '/stats/:id/:hero' do
  content_type :json
  if in_database?(params[:id].gsub('-','#'))
    bnet_id = params[:id].gsub('-','#')
  else
    bnet_id = battle_net_id(params[:id])
  end
  puts bnet_id
  if !in_database?(bnet_id)
    crawl_stats(bnet_id)
  elsif !params[:stat].nil?
      return get_stats(bnet_id)[params[:hero]][params[:stat]].to_json
  else
    return get_stats(bnet_id)[params[:hero]].to_json
  end
end
