require_relative '../lib/board_and_pieces'

describe Knight do

  let(:knight) { Knight.new([1,2],"white") }
  let(:empty_board) { [knight] }
  let(:board_with_pawns) { [knight,Pawn.new([3,1],"white"),Pawn.new([2,2],"black"),Pawn.new([2,3],"black"),Pawn.new([2,4],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(knight.position).to eql [1,2]
    end
    it 'starts with a color' do
      expect(knight.color).to eql "white"
    end
  end
  
  describe 'movement' do
    it 'has correct number of available moves' do
      expect(knight.available_moves(empty_board).count).to eql 3
    end
    it 'moves to an empty space' do
      knight.move([3,1],empty_board)
      expect(knight.position).to eql [3,1]
    end
    it 'doesnt make invalid move' do
      knight.move([5,5],empty_board)
      expect(knight.position).to eql [1,2]
    end
    it 'can not move off board' do
      knight.move([0,0],empty_board)
      expect(knight.position).to eql [1,2]
    end
    it 'doesnt move to friendly occupied space' do
      knight.move([3,1],board_with_pawns)
      expect(knight.position).to eql [1,2]
    end
  end
  
  describe 'taking enemy piece' do
    it 'moves to space containing enemy piece' do
      knight.move([2,4],board_with_pawns)
      expect(knight.position).to eql [2,4]
    end
  end
  
end

