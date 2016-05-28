require 'httparty'
require 'nokogiri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

user=ARGV[0]
uid=ARGV[1]

if user.nil? || uid.nil?
  abort("ABORT.. Missing info\nUsage: ruby script.rb <GamerTag> <TagReferenceNumber>")
end
page = HTTParty.get("https://playoverwatch.com/en-us/career/pc/us/#{user}-#{uid}")
doc = Nokogiri::HTML(page)

# Get catagories
catagories = []
doc.xpath('//*[@id="stats-section"]/div/select/option').each do |i|
  catagories.push(i.text)
end
# Create Hash structure for data
data = Hash.new()
catagories.each do |category|
  data[category]={}
end

# Crawl through data and add to structure!
catagories.each_with_index do |category, i|
  doc.xpath('//*[@id="stats-section"]/div/div').children[i].xpath('div/div/table/tbody').each do |item|
    puts item.class
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
File.open("#{user}.csv",'w') do |file|
  output.each do |row|
    file.write(row)
    file.write("\n")
  end
end
