require './lib/board'
require './lib/ship'
require './lib/cell'

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  it 'exists' do 
    expect(@board).to be_an_instance_of(Board)
  end
  
  it 'has cells' do
    expected_data = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
    expect(@board.cells.keys).to eq(expected_data)
  end

  it "validates coordinate" do 
    expect(@board.valid_coordinate?("A1")).to eq(true)
    expect(@board.valid_coordinate?("D4")).to eq(true)
    expect(@board.valid_coordinate?("A5")).to eq(false)
    expect(@board.valid_coordinate?("E1")).to eq(false)
    expect(@board.valid_coordinate?("A22")).to eq(false)
  end

  it "validates ship placement according to length" do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to eq(false)
  end

  it "validates that coordinates are consecutive" do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to eq(false)
  end

  it "has a diagonal_coordinates helper" do 
    expect(@board.diagonal_coordinates?(["B3", "B4"])).to eq(false)
    expect(@board.diagonal_coordinates?(["C2", "D1"])).to eq(true)
    expect(@board.diagonal_coordinates?(["A1", "B2"])).to eq(true)
    expect(@board.diagonal_coordinates?(["A1", "A2"])).to eq(false)
  end

  it "has a consecutive coordinates helper" do 
    expect(@board.consecutive_coordinates?(["A1", "A4"])).to eq(false)
    expect(@board.consecutive_coordinates?(["A1", "A2"])).to eq(true)
  end

  it "has a overlap helper" do 
    @board.place(@cruiser, ["A1", "B1", "C1"])
    @board.place(@submarine, ["B3", "B4"])

    expect(@board.overlap?(["A1", "A2", "A3"])).to eq(true)
    expect(@board.overlap?(["D1", "D2"])).to eq(false)
    expect(@board.overlap?(["B3", "B4"])).to eq(true)
    expect(@board.overlap?(["D3", "D4"])).to eq(false)
  end

  it "validates that ships can't be placed diagonally" do
    expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to eq(false)
  end

  it "validates placement" do
    expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to eq(true)
    expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to eq(true)
  end

  it "places ships" do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @cell = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
    expect(@cell.ship).to eq(@cruiser)
    expect(@cell_2.ship).to eq(@cruiser)
    expect(@cell_3.ship).to eq(@cruiser)
    expect(@cell_3.ship == @cell_2.ship).to eq(true)
  end

  it "does not allow ships to overlap" do
    @board.place(@cruiser, ["A1", "A2", "A3"]) 
    expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to eq(false)
  end

  it "renders the board" do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
    expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
  end

  it "renders hits, misses and sunken ships" do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["C1", "D1"])
    @cell = @board.cells["A1"]
    @cell_2 = @board.cells["B4"]
    @cell_3 = @board.cells["C1"]
    @cell_4 = @board.cells["D1"]
    @cell.fire_upon
    @cell_2.fire_upon
    @cell_3.fire_upon
    @cell_4.fire_upon

    expect(@board.render(true)).to eq("  1 2 3 4 \n" +
                                      "A H S S . \n" +
                                      "B . . . M \n" +
                                      "C X . . . \n" +
                                      "D X . . . \n")
  end
end 
