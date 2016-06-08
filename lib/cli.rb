require 'httparty'
require 'nokogiri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

input=ARGV[0]
=begin
if redis[bnet_id].nil?
  # Get data and store in database
else
  # Data exists, pull data and return values.
end
=end
if input.nil?
  abort("Usage: ruby script.rb <GamerTag or Battlenet ID>")#ABORT.. Missing info\nUsage: ruby script.rb <PC/PS4/XBOX> <GamerTag> <BattleTagReferenceNumber>")
end

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

  # Generate Output array
  output = []
  data.each do |category|
    category[1].each do |item|
      output.push("#{category[0]},#{item[0]},#{item[1].gsub(",",'')}")
    end
  end

  # Write to file
  system('mkdir tmp')
  File.open("tmp/#{bnet_id.gsub("#","-")}.csv",'w') do |file|
    data.each do |category|
      category[1].each do |item|
        file.write("#{category[0]},#{item[0]},#{item[1].gsub(",",'')}")
        file.write("\n")
      end
    end
  end
  File.open("#{bnet_id.gsub("#","-")}.json",'w') do |file|
    file.write(data.to_json)
  end
end

get_stats(battle_net_id(ARGV[0]))
