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
    let(:white_pieces) { chess_game.pieces.select { |i| i.color == "white" } }
    let(:black_pieces) { chess_game.pieces.select { |i| i.color == "black" } }
    
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
      expect(black_pieces.count).to eql 16
      expect(white_pieces.count).to eql 16
    end
  end
  
  describe '#display_board' do
    it 'displays starting board correctly' do
      target_board = "  1 2 3 4 5 6 7 8\n8 ♜ ♞ ♝ ♚ ♛ ♝ ♞ ♜\n7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟\n6 _ _ _ _ _ _ _ _\n5 _ _ _ _ _ _ _ _\n4 _ _ _ _ _ _ _ _\n3 _ _ _ _ _ _ _ _\n2 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n1 ♖ ♘ ♗ ♔ ♕ ♗ ♘ ♖"
      expect(chess_game.display_board).to eql target_board
    end
  end
  
  describe '#check' do
    let(:situation1) { [King.new([1,4],"white"),Queen.new([8,4],"black")] }
    let(:situation2) { [King.new([1,4],"black"),Queen.new([8,4],"white")] }
    let(:situation3) { [King.new([1,4],"white"),Queen.new([8,4],"black"),Pawn.new([2,4],"white")] }
    
    it 'returns true when king is in check' do
      expect(chess_game.check?("white",situation1)).to be_truthy
    end
    it 'returns true when colors reversed' do
      expect(chess_game.check?("black",situation2)).to be_truthy
    end
    it 'return false when friendly piece is blocking' do
      expect(chess_game.check?("white",situation3)).to be_falsey
    end
  end
  
  describe '#checkmate' do
    let(:situation1) { [King.new([1,4],"white"),King.new([3,4],"black"),Queen.new([1,1],"black")] }
    let(:situation2) { [King.new([1,4],"black"),King.new([3,4],"white"),Queen.new([1,1],"white")] }
    let(:situation3) { [King.new([1,4],"white"),King.new([3,3],"black"),Queen.new([1,1],"black")] }
    let(:situation4) { [King.new([1,8],"white"),Bishop.new([4,6],"black"),Rook.new([8,7],"black"),Knight.new([2,6],"black")] }
    
    it 'returns true when king is checkmated by king and queen' do
      chess_game.pieces = situation1
      expect(chess_game.checkmate?("white")).to be_truthy
    end
    it 'returns true when colors reversed' do
      chess_game.pieces = situation2
      expect(chess_game.checkmate?("black")).to be_truthy
    end
    it 'returns false when king has way out' do
      chess_game.pieces = situation3
      expect(chess_game.checkmate?("white")).to be_falsey
    end
    it 'returns true when king checkmated by rook, bishop, and knight' do
      chess_game.pieces = situation4
      expect(chess_game.checkmate?("white")).to be_truthy
    end
  end

end
