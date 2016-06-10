require 'rspec'
require './main.rb'

## Tests for battle_net_id() ##
# Standard Input Expectation
=begin
describe 'battle_net_id' do
  it 'Verifies Battlenet ID' do
    result = battle_net_id('BlueShoesYes-1548')
    expect(result).to eq 'BlueShoesYes#1548'
  end
end

# Situational Input
describe 'battle_net_id' do
  it 'Verifies Battlenet ID' do
    result = battle_net_id('BlueShoesYes#1548')
    expect(result).to eq 'BlueShoesYes#1548'
  end
end
=end
# Console Input
#describe 'battle_net_id' do
#  it 'Verifies Battlenet ID' do
#    result = battle_net_id('m_shad0w_06')
#    expect(result).to eq 'm_shad0w_06#psn'
#  end
#end

describe BattleNetId do
  it '.initialize' do
    bnet_id = BattleNetId.new('BlueShoesYes-1548').to_s
    expect(bnet_id).to eq 'BlueShoesYes#1548'
  end
  it '.initialize' do
    bnet_id = BattleNetId.new('m_shad0w_06').to_s
    expect(bnet_id).to eq 'm_shad0w_06#psn'
  end
  it '.crawl_stats' do
    bnet_id = BattleNetId.new('BlueShoesYes-1548')
    expect(bnet_id.crawl_stats).to eq true
  end

  it '.crawl_stats' do
    bnet_id = BattleNetId.new('m_shad0w_06#psn')
    expect(bnet_id.crawl_stats).to eq true
  end

  it '.crawl_stats' do
    bnet_id = BattleNetId.new('FakeNameInsertHere- LOL')
    expect(bnet_id.crawl_stats).to eq false
  end

  it '.get_stats' do
    bnet_id = BattleNetId.new('BlueShoesYes-1548')
    expect(bnet_id.get_stats).not_to eq nil
  end
  it '.get_stats' do
    bnet_id = BattleNetId.new('BlueShoesYes')
    expect(bnet_id.get_stats).to eq nil
  end
end

## Tests for methodname() ##
