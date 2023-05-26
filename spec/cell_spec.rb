require './lib/ship'
require './lib/cell'

RSpec.describe Cell do
  before(:each) do
  @cell = Cell.new('B4')
  @cruiser = Ship.new("Cruiser", 3)
  end

  it 'exists' do
    expect(@cell).to be_an_instance_of(Cell)
  end

  it 'has attributes' do 
    expect(@cell.coordinate).to eq("B4")
    expect(@cell.ship).to eq(nil)
  end

  it 'starts out empty' do 
    expect(@cell.empty?).to eq(true)
  end

  it 'places ship' do 
    @cell.place_ship(@cruiser)

    expect(@cell.ship).to eq(@cruiser)
    expect(@cell.empty?).to eq(false)
  end
end