require_relative '../lib/board_and_pieces'

describe King do

  let(:king) { King.new([1,4],"white") }
  let(:empty_board) { [king] }
  let(:board_with_pawns) { [king,Pawn.new([2,3],"white"),Pawn.new([2,4],"black")] }
 
  describe '#initialize' do
    it 'starts with a position' do
      expect(king.position).to eql [1,4]
    end
    it 'starts with a color' do
      expect(king.color).to eql "white"
    end
  end

  describe 'movement' do
    it 'has correct number of available moves' do
      expect(king.available_moves(empty_board).count).to eql 5
    end
    it 'moves to an empty space' do
      king.move([2,4],empty_board)
      expect(king.position).to eql [2,4]
    end
    it 'can not make invalid move' do
      king.move([5,5],empty_board)
      expect(king.position).to eql [1,4]
    end
    it 'can not move off board' do
      king.move([-1,4],empty_board)
      expect(king.position).to eql [1,4]
    end
    it 'doesnt move forward into occupied space' do
      king.move([2,3],board_with_pawns)
      expect(king.position).to eql [1,4]
    end
  end
  
  describe 'taking enemy piece' do
    it 'moves into enemy occupied space' do
      king.move([2,4],board_with_pawns)
      expect(king.position).to eql [2,4]
    end
  end

end
