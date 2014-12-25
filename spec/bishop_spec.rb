require_relative '../lib/board_and_pieces'

describe Bishop do

  let(:bishop) { Bishop.new([1,3],"white") }
  let(:empty_board) { [bishop] }
  let(:board_with_pawns) { [bishop,Pawn.new([3,1],"white"),Pawn.new([3,5],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(bishop.position).to eql [1,3]
    end
    it 'starts with a color' do
      expect(bishop.color).to eql "white"
    end
  end

  describe 'movement' do
    it 'has correct number of available moves' do
      expect(bishop.available_moves(empty_board).count).to eql 7
    end
    it 'moves to an empty space' do
      bishop.move([3,1],empty_board)
      expect(bishop.position).to eql [3,1]
    end
    it 'doesnt make invalid move' do
      bishop.move([4,3],empty_board)
      expect(bishop.position).to eql [1,3]
    end
    it 'can not move off board' do
      bishop.move([4,-1],empty_board)
      expect(bishop.position).to eql [1,3]
    end
    it 'doesnt move to friendly occupied space' do
      bishop.move([3,1],board_with_pawns)
      expect(bishop.position).to eql [1,3]
    end
  end

  describe 'taking enemy piece' do
    it 'moves to space containing enemy piece' do
      bishop.move([2,4],board_with_pawns)
      expect(bishop.position).to eql [2,4]
    end
  end

end

