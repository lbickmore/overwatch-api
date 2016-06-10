require 'httparty'
require 'nokogiri'
require 'openssl'
require 'redis'
#require config file eventually

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

$redis = Redis.new(:password => 'foobared', :url => "redis://192.241.220.104")

class BattleNetId
  def initialize(input)
    @bnet_id = input.strip.gsub('-','#').gsub(' ','')
    if (@bnet_id.include? '#') && (!@bnet_id.split('#')[1].include?('psn')) && (!@bnet_id.split('#')[1].include?('xbl'))

      # Check database for full bnet_id
      if self.in_database?
        puts " #{@bnet_id} In Database!"
        return @bnet_id
      end
      puts " #{@bnet_id} Not in Database "
      # Check for PC user
      id = @bnet_id.split('#')
      page = HTTParty.get("https://playoverwatch.com/en-us/career/pc/us/#{id[0]}-#{id[1]}")
      pc = Nokogiri::HTML(page)
      if pc.inner_html.include? "Page Not Found"
        @bnet_id = 'No User Found'
      else
        return @bnet_id
      end
    else # for console users
      puts " #{@bnet_id} Console"
      # Check for Playstation Network user
      page = HTTParty.get("https://playoverwatch.com/en-us/career/psn/#{@bnet_id}")
      psn = Nokogiri::HTML(page)
      if !psn.inner_html.include? "Page Not Found"
        if @bnet_id.include? '#psn'
          return @bnet_id
        else
          @bnet_id = @bnet_id + '#psn'
          return @bnet_id + '#psn'
        end
      end
      if psn.inner_html.include? "Page Not Found"
        # Check for Xbox Live user
        page = HTTParty.get("https://playoverwatch.com/en-us/career/xbl/#{@bnet_id}")
        xbl = Nokogiri::HTML(page)
        if !xbl.inner_html.include? "Page Not Found"
          if @bnet_id.include? '#xbl'
            return @bnet_id
          else
            @bnet_id = @bnet_id + '#xbl'
            return @bnet_id + '#xbl'
          end
        end
      end
      @bnet_id = 'No User Found'
    end
  end

  def to_s
    @bnet_id
  end

  def crawl_stats
    if @bnet_id == 'No User Found'
      return false
    end

    redis = $redis
    bnet_arr = @bnet_id.split('#')
    if !/\A\d+\z/.match(bnet_arr[1]) # if bnet_arr[1] is not a number
      page = HTTParty.get("https://playoverwatch.com/en-us/career/#{bnet_arr[1]}/#{bnet_arr[0]}")
    else # if bnet_arr[1] is a number
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
    redis.set @bnet_id, data.to_json.gsub("Lúcio","Lucio").gsub("Torbjörn","Torbjorn")
    return !redis[@bnet_id].empty?
  end

  # Check if a bnet_id is in the database
  def in_database?
    redis=$redis
    users = redis.keys
    return users.include? @bnet_id
  end

  # Get JSON of stats to return for a specific user
  def get_stats
    redis = $redis
    if redis.get(@bnet_id).nil?
      return nil
    end
    return JSON.parse(redis.get(@bnet_id))
  end
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
