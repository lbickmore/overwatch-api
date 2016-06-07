require 'httparty'
require 'nokogiri'
require 'openssl'
require 'redis'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

$redis = Redis.new(:password => $redis_pass, :url => 'redis://192.241.220.104')

def battle_net_id(id)
  puts 'Running battle_net_id'
  #redis = $redis
  id = id.strip.gsub('-','#')

  # Check redis before checking playoverwatch.com
  #users=[]
  #redis.keys.each { |i| users.push(i.split('#')[0])}
  #if users.include? id

  if id.include? '#'
    # Check for PC user
    x = id.split('#')
    page = HTTParty.get("https://playoverwatch.com/en-us/career/pc/us/#{x[0]}-#{x[1]}")
    pc = Nokogiri::HTML(page)
    if !pc.inner_html.include? "Page Not Found"
      return id
    end
  else
    # Check for Playstation Network user
    page = HTTParty.get("https://playoverwatch.com/en-us/career/psn/#{id}")
    psn = Nokogiri::HTML(page)
    if !psn.inner_html.include? "Page Not Found"
      return id + '#psn'
    end
    if psn.inner_html.include? "Page Not Found"
      # Check for Xbox Live user
      page = HTTParty.get("https://playoverwatch.com/en-us/career/xbl/#{id}")
      xbl = Nokogiri::HTML(page)
      if !xbl.inner_html.include? "Page Not Found"
        return id + '#xbl'
      end
    end
    return 'No User Found'
  end
end


def crawl_stats(bnet_id)
  puts 'Running crawl_stats'
  if bnet_id == 'No User Found'
    return bnet_id
  end

  redis = $redis
  bnet_arr = bnet_id.split('#')
  if !/\A\d+\z/.match(bnet_arr[1]) #if not a number
    page = HTTParty.get("https://playoverwatch.com/en-us/career/#{bnet_arr[1]}/#{bnet_arr[0]}")
  else
    page = HTTParty.get("https://playoverwatch.com/en-us/career/pc/us/#{bnet_arr[0]}-#{bnet_arr[1]}")
  end

  doc = Nokogiri::HTML(page)

  # Get categories
  categories = []
  doc.xpath('//*[@id="stats-section"]/div/select/option').each do |i|
    #print i.text; puts
    #print i.text.gsub("Lúcio","Lucio").gsub("Torbjörn","Torbjorn"); puts; puts
    categories.push(i.text)
  end

  # Create Hash structure for data
  data = Hash.new()
  categories.each do |category|
    data[category]={}
  end

  # Crawl through data and add to structure!
  categories.each_with_index do |category, i|
    doc.xpath('//*[@id="stats-section"]/div/div').children[i].xpath('div/div/table/tbody').each do |item|
      item.children.children.children.each_slice(2).to_a.each do |input|
        data[category][input[0].text] = input[1].text
      end
    end
  end
  redis.set bnet_id, data.to_json.gsub("Lúcio","Lucio").gsub("Torbjörn","Torbjorn")
end

#
def get_stats(bnet_id)
  puts 'Running get_stats'
  redis = $redis
  if redis.get(bnet_id).nil?
    return nil
  end
  return JSON.parse(redis.get(bnet_id))
end

# Dump entire database to JSON
def data_dump()
  puts 'Running data_dump'
  redis = $redis
  everyone = redis.keys
  results = "{"
  everyone.each do |bnet_id|
    if bnet_id == everyone[(everyone.length - 1)]
      results = results + "\"#{bnet_id}\":" + redis.get(bnet_id)+ "}"
    else
      results = results + "\"#{bnet_id}\":" + redis.get(bnet_id) + ","
    end
  end
  return results
end

def in_database?(bnet_id)
  print 'Running in_database? '
  redis=$redis
  users = redis.keys
  puts users.include? bnet_id
  return users.include? bnet_id
end
