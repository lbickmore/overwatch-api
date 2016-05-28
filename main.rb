require 'httparty'
require 'nokogiri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

page = HTTParty.get('https://playoverwatch.com/en-us/career/pc/us/BlueShoesYes-1548')
doc = Nokogiri::HTML(page)

# Get Catagories
catagories = []
doc.xpath('//*[@id="stats-section"]/div/select/option').each do |i|
  catagories.push(i.text)
end

data = Hash.new()
catagories.each do |category|
  data[category]={}
end

catagories.each_with_index do |category, i|
  doc.xpath('//*[@id="stats-section"]/div/div').children[i].xpath('div/div/table/tbody').each do |item|
    puts item.class
    item.children.children.children.each_slice(2).to_a.each do |input|
      data[category][input[0].text] = input[1].text
    end
  end
end
puts data['Mercy']['Offensive Assists - Average']








doc.xpath('//*[@id="stats-section"]/div/div').children[i].xpath('div/div/table/tbody').children.children.children.each_slice(2).to_a


catagories.each do |category|
  doc.xpath('//*[@id="stats-section"]/div/div/div[1]/div/div/table/tbody').each do |item|

# Here you can call data_raw[catagories[n]].inner_html



all_tables=[]
doc.xpath('//*[@id="stats-section"]/div/div/div/div/div/table/tbody').each do |item|
  all_tables.push(item.children.children.children.each_slice(2).to_a)
end
data_raw={}
all_tables.each do |table|
  table.each do |i|
    if data_raw[i[0].text]
      data_raw[i[0].text+' dup'] = i[1].text
    else
      data_raw[i[0].text] = i[1].text
    end
  end
end
data_raw.each do |row|
  puts "#{row[0]},#{row[1].gsub(",",'')}"
end

#parse_page = Nokogiri::HTML(page)

#headers_str = parse_page.css('.js-career-select').children.to_html.gsub("General", "\nGeneral")
#headers_arr = headers_str.gsub(%r{</?[^>]+?>}, '').split("\n")

=begin
raw_arr = parse_page.css('.data_raw-table').to_a
clean_arr = []
raw_arr.each do |table|
  table.inner_html.split("\n").each do |row|
    if row != '</tr>' && row != '<tr>' && row != '</td>' && row != '</td>' && row != '<tbody>' && row != '</tbody>' && !row.include?("thead")
      row = row.gsub(%r{</?[^>]+?>}, '')
      if row.to_s.strip.length != 0
        clean_arr.push(row)
      end
    end
  end
end
data_raw_hash = Hash[clean_arr.each_slice(2).to_a]
puts clean_arr
=end

#puts parse_page.css('.js-career-select').inner_html.gsub(%r{</?[^>]+?>}, '').split("\n")
#puts parse_page.css('.dropdown_original').inner_html.gsub(%r{</?[^>]+?>}, '').split("\n")


#parse_page.xpath('//*[@id="stats-section"]/div/div[2]/div[1]/div[1]/div/table/tbody/tr')
####################
####################
#Section = doc.xpath('//*[@id="stats-section"]/div/div/div/div/div/table/tbody')


#h = Hash[doc.xpath('//*[@id="stats-section"]/div/div/div/div/div/table/tbody/tr').children.children.each_slice(2).to_a]
