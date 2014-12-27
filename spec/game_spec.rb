require_relative '../lib/game'

describe Chess do
  
  let(:chess_game) { Chess.new }

  describe '#initialize' do
    let(:pawns) { chess_game.pieces.select { |i| i.class == Pawn } }
    let(:rooks) { chess_game.pieces.select { |i| i.class == Rook } }
    let(:bishops) { chess_game.pieces.select { |i| i.class == Bishop } }
    let(:knights) { chess_game.pieces.select { |i| i.class == Knight } }
    let(:queens) { chess_game.pieces.select { |i| i.class == Queen } }
    let(:kings) { chess_game.pieces.select { |i| i.class == King } }
    
    it 'initializes with correct number of pieces' do
      expect(chess_game.pieces.count).to eql 32
    end
    it 'has correct number of each piece type' do
      expect(pawns.count).to eql 16
      expect(rooks.count).to eql 4
      expect(bishops.count).to eql 4
      expect(knights.count).to eql 4
      expect(queens.count).to eql 2
      expect(kings.count).to eql 2
    end
    it 'has correct number of each piece color' do
      expect(chess_game.white_pieces.count).to eql 16
      expect(chess_game.black_pieces.count).to eql 16
    end
  end
  
  describe '#display_board' do
    it 'displays starting board correctly' do
      target_board = "  1 2 3 4 5 6 7 8\n8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜\n7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟\n6 _ _ _ _ _ _ _ _\n5 _ _ _ _ _ _ _ _\n4 _ _ _ _ _ _ _ _\n3 _ _ _ _ _ _ _ _\n2 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖"
      expect(chess_game.display_board).to eql target_board
    end
  end

end
