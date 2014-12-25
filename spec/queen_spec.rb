require_relative '../lib/board_and_pieces'

describe Queen do

  let(:queen) { Queen.new([1,5],"white") }
  let(:empty_board) { [queen] }
  let(:board_with_pawns) { [queen,Pawn.new([4,2],"white"),Pawn.new([4,5],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(queen.position).to eql [1,5]
    end
    it 'starts with a color' do
      expect(queen.color).to eql "white"
    end
  end

  describe 'movement' do
    it 'has correct number of available moves' do
      expect(queen.available_moves(empty_board).count).to eql 21
    end
    it 'moves digonally to an empty space' do
      queen.move([3,7],empty_board)
      expect(queen.position).to eql [3,7]
    end
    it 'moves straight to an empty space' do
      queen.move([5,5],empty_board)
      expect(queen.position).to eql [5,5]
    end
    it 'doesnt make invalid move' do
      queen.move([3,4],empty_board)
      expect(queen.position).to eql [1,5]
    end
    it 'can not move off board' do
      queen.move([-1,5],empty_board)
      expect(queen.position).to eql [1,5]
    end
    it 'doesnt move to friendly occupied space' do
      queen.move([4,2],board_with_pawns)
      expect(queen.position).to eql [1,5]
    end
  end

  describe 'taking enemy piece' do
    it 'moves to space containing enemy piece' do
      queen.move([4,5],board_with_pawns)
      expect(queen.position).to eql [4,5]
    end
  end

end
