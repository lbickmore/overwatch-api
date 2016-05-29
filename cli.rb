require 'httparty'
require 'nokogiri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

sys_type=ARGV[0]
gtag=ARGV[1]
gtag_id=ARGV[2]

if gtag.nil? || sys_type.nil?
  abort("ABORT.. Missing info\nUsage: ruby script.rb <PC/PS4/XBOX> <GamerTag> <BattleTagReferenceNumber>")
end

if sys_type.downcase.strip == 'pc' && !gtag_id.nil?
  page = HTTParty.get("https://playoverwatch.com/en-us/career/pc/us/#{gtag}-#{gtag_id}")
  bnet_id= "#{gtag}##{gtag_id}"
else
  if sys_type.downcase.strip == 'ps4'
    page = HTTParty.get("https://playoverwatch.com/en-us/career/psn/#{gtag}")
    bnet_id= "#{gtag}#ps4"
  else
    if sys_type.downcase.strip == 'xbox'
      page = HTTParty.get("https://playoverwatch.com/en-us/career/xbl/#{gtag}")
      bnet_id= "#{gtag}#xbox"
    else
      abort("Invalid Input\nUsage: ruby script.rb <PC/PS4/XBOX> <GamerTag> <BattleTagReferenceNumber>")
    end
  end
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
File.open("#{bnet_id.gsub("#","-")}.csv",'w') do |file|
  data.each do |category|
    category[1].each do |item|
      file.write("#{category[0]},#{item[0]},#{item[1].gsub(",",'')}")
      file.write("\n")
    end
  end
end
