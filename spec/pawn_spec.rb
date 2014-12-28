require_relative '../lib/board_and_pieces'

describe Pawn do

  let(:pawn) { Pawn.new([2,2],"white") }
  let(:black_pawn) { Pawn.new([7,2],"black") }
  let(:empty_board) { [pawn] }
  let(:board_with_pawns) { [pawn,Pawn.new([3,1],"white"),Pawn.new([3,2],"black"),Pawn.new([3,3],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(pawn.position).to eql [2,2]
    end
    it 'starts with a color' do
      expect(pawn.color).to eql "white"
    end
  end

  describe 'movement' do
    it 'has correct number of available moves' do
      expect(pawn.available_moves(empty_board).count).to eql 2
      expect(black_pawn.available_moves(empty_board).count).to eql 2
    end
    it 'moves to an empty space' do
      pawn.move([4,2],empty_board)
      expect(pawn.position).to eql [4,2]
    end
    it 'moves opposite direction when black' do
      black_pawn.move([5,2],empty_board)
      expect(black_pawn.position).to eql [5,2]
    end
    it 'can not move two forward after already moving' do
      pawn.move([3,2],empty_board)
      pawn.move([5,2],empty_board)
      expect(pawn.position).to eql [3,2]
    end
    it 'can not make invalid move' do
      pawn.move([5,5],empty_board)
      expect(pawn.position).to eql [2,2]
    end
    it 'doesnt move forward into occupied space' do
      pawn.move([3,2],board_with_pawns)
      expect(pawn.position).to eql [2,2]
    end
  end
  
  describe 'taking enemy piece' do
    it 'moves diagonally to space containing enemy piece' do
      pawn.move([3,3],board_with_pawns)
      expect(pawn.position).to eql [3,3]
    end
    it 'doesnt move diagonally to space containing friendly piece' do
      pawn.move([3,1],board_with_pawns)
      expect(pawn.position).to eql [2,2]
    end
  end
end

