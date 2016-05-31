require 'httparty'
require 'nokogiri'
require 'openssl'
require 'redis'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def battle_net_id(id)
  id = id.strip
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


def get_stats(bnet_id)
  #Usage: ruby script.rb <GamerTag or Battlenet ID>"
  if bnet_id == 'No User Found'
    puts bnet_id
    return bnet_id
  end
  redis = Redis.new
  #redis = Redis.new(:url => 'redis://IPHERE')
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
  redis.set bnet_id, data.to_json
end

get_stats(battle_net_id(ARGV[0]))
