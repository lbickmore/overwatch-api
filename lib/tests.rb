require 'rspec'
require './main.rb'

## Tests for battle_net_id() ##
# Standard Input Expectation
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

# Console Input
describe 'battle_net_id' do
  it 'Verifies Battlenet ID' do
    result = battle_net_id('m_shad0w_06')
    expect(result).to eq 'm_shad0w_06#psn'
  end
end


## Tests for methodname() ##
