require_relative '../lib/board_and_pieces'

describe Rook do

  let(:rook) { Rook.new([1,1],"white") }
  let(:empty_board) { [rook] }
  let(:board_with_pieces) { [rook,Pawn.new([4,1],"white"),Bishop.new([1,5],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(rook.position).to eql [1,1]
    end
    it 'starts with a color' do
      expect(rook.color).to eql "white"
    end
  end

  describe 'movement' do
    it 'has correct number of available moves' do
      expect(rook.available_moves(empty_board).count).to eql 14
    end
    it 'moves to an empty space' do
      rook.move([8,1],empty_board)
      expect(rook.position).to eql [8,1]
    end
    it 'doesnt make invalid move' do
      rook.move([3,3],empty_board)
      expect(rook.position).to eql [1,1]
    end
    it 'can not move off board' do
      rook.move([1,-1],empty_board)
      expect(rook.position).to eql [1,1]
    end
    it 'doesnt move to friendly occupied space' do
      rook.move([4,1],board_with_pieces)
      expect(rook.position).to eql [1,1]
    end
  end

  describe 'taking enemy piece' do
    it 'moves to space containing enemy piece' do
      rook.move([1,5],board_with_pieces)
      expect(rook.position).to eql [1,5]
    end
  end
  
end
