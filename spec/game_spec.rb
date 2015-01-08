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
      target_board = "  a b c d e f g h\n8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜\n7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟\n6 _ _ _ _ _ _ _ _\n5 _ _ _ _ _ _ _ _\n4 _ _ _ _ _ _ _ _\n3 _ _ _ _ _ _ _ _\n2 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖"
      expect(chess_game.display_board).to eql target_board
    end
  end
  
  describe 'input' do
    let(:situation1) { [Queen.new([4,4],"white")] }
    
    it 'accepts valid input' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "d4 to d5" }
      expect(chess_game).not_to receive(:puts).with("Please enter a valid move!\ne.g. \"b2 to b4\"")
      chess_game.player_input("white")
    end
    
    it 'does not accept blank input' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "" }
      expect(chess_game).to receive(:puts).with("Please enter a valid move!\ne.g. \"b2 to b4\"")
      chess_game.player_input("white")
    end
    
    it 'does not accept nonsense input' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "asd%&(*$#*fasdfa" }
      expect(chess_game).to receive(:puts).with("Please enter a valid move!\ne.g. \"b2 to b4\"")
      chess_game.player_input("white")
    end
    
  end
  
  describe 'movement' do
    let(:queen) { Queen.new([4,4],"white") }
    let(:pawn) { Pawn.new([4,1],"black") }
    let(:situation1) {[queen,pawn]}
    
    it 'allows piece to move' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "d4 to h8" }
      chess_game.player_input("white")
      expect(queen.position).to eql [8,8]
    end
    it 'doesnt allow invalid move' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "d4 to g8" }
      chess_game.player_input("white")
      expect(queen.position).to eql [4,4]
    end
    it 'remove piece from board when it is taken' do
      chess_game.pieces = situation1
      allow(chess_game).to receive(:gets) { "d4 to a4" }
      chess_game.player_input("white")
      expect(situation1.count).to eql 1
    end
  end
  
  describe '#check?' do
    let(:situation1) { [King.new([1,4],"white"),Queen.new([8,4],"black")] }
    let(:situation2) { [King.new([1,4],"black"),Queen.new([8,4],"white")] }
    let(:situation3) { [King.new([1,4],"white"),Queen.new([8,4],"black"),Pawn.new([2,4],"white")] }
    let(:situation4) { [King.new([1,4],"white"),Rook.new([8,5],"black"),Bishop.new([2,3],"black"),Queen.new([5,6],"black")] }
    
    it 'returns true when king is in check' do
      expect(chess_game.check?("white",situation1)).to be_truthy
    end
    it 'returns true when colors reversed' do
      expect(chess_game.check?("black",situation2)).to be_truthy
    end
    it 'return false when friendly piece is blocking' do
      expect(chess_game.check?("white",situation3)).to be_falsey
    end
    it 'king can not move into check' do
      chess_game.pieces = situation4
      allow(chess_game).to receive(:gets) { "d1 to e1" }
      expect(chess_game).to receive(:puts).with("Please enter a valid move!\ne.g. \"b2 to b4\"")
      chess_game.player_input("white")
    end
    it 'king can not take covered piece' do
      chess_game.pieces = situation4
      allow(chess_game).to receive(:gets) { "d1 to c2" }
      expect(chess_game).to receive(:puts).with("Please enter a valid move!\ne.g. \"b2 to b4\"")
      chess_game.player_input("white")
    end
  end
  
  describe '#checkmate?' do
    let(:situation1) { [King.new([1,4],"white"),King.new([3,4],"black"),Queen.new([1,1],"black")] }
    let(:situation2) { [King.new([1,4],"black"),King.new([3,4],"white"),Queen.new([1,1],"white")] }
    let(:situation3) { [King.new([1,4],"white"),King.new([3,3],"black"),Queen.new([1,1],"black")] }
    let(:situation4) { [King.new([1,8],"white"),Bishop.new([4,6],"black"),Rook.new([8,7],"black"),Knight.new([2,6],"black")] }
    let(:situation5) { [King.new([1,4],"white"),Pawn.new([2,3],"black"),Pawn.new([3,4],"black"),Pawn.new([2,5],"black")] }
    
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
    it 'returns false when king checked by three pawns' do
      chess_game.pieces = situation5
      expect(chess_game.checkmate?("white")).to be_falsey
    end
  end
  
  describe '#stalemate?' do
    let(:situation1) { [King.new([1,5],"white"),Rook.new([8,4],"black"),Rook.new([8,6],"black"),Queen.new([2,1],"black")] }
    
    it 'returns true when king cannot move but is not in check' do
      chess_game.pieces = situation1
      expect(chess_game.stalemate?("white")).to be_truthy
    end
  end
  
  describe 'castling' do 
    let(:situation1) { [King.new([1,5],"white"),Rook.new([1,1],"white"),Rook.new([1,8],"white")] }
    let(:situation2) { [King.new([8,5],"black"),Rook.new([8,1],"black")] }
    let(:situation3) { [King.new([1,5],"white"),Rook.new([1,1],"white"),Rook.new([8,3],"black")] }
    let(:situation4) { [King.new([1,5],"white"),Rook.new([1,1],"white"),Knight.new([1,2],"white")] }
    
    it 'castles left' do
      chess_game.pieces = situation1
      king = situation1.find { |piece| piece.class == King }
      allow(chess_game).to receive(:gets) { "castle left" }
      chess_game.player_input("white")
      expect(king.position).to eql [1,3]
    end
    
    it 'castles left when black' do
      chess_game.pieces = situation2
      king = situation2.find { |piece| piece.class == King }
      allow(chess_game).to receive(:gets) { "castle left" }
      chess_game.player_input("black")
      expect(king.position).to eql [8,3]
    end
    
    it 'can not castle after piece has moved' do
      chess_game.pieces = situation1
      rook = situation1.find { |piece| piece.class == Rook && piece.position == [1,1] }
      rook.move([1,4],situation1)
      allow(chess_game).to receive(:gets) { "castle left" }
      expect(chess_game).to receive(:puts).with("You can not castle left at this time.")
      chess_game.player_input("white")
    end
    
    it 'can not castle into check' do
      chess_game.pieces = situation3
      allow(chess_game).to receive(:gets) { "castle left" }
      expect(chess_game).to receive(:puts).with("You can not castle left at this time.")
      chess_game.player_input("white")
    end
    
    it 'can not castle with pieces in between' do
      chess_game.pieces = situation4
      allow(chess_game).to receive(:gets) { "castle left" }
      expect(chess_game).to receive(:puts).with("You can not castle left at this time.")
      chess_game.player_input("white")
    end
    
    it 'castles right' do
      chess_game.pieces = situation1
      king = situation1.find { |piece| piece.class == King }
      allow(chess_game).to receive(:gets) { "castle right" }
      chess_game.player_input("white")
      expect(king.position).to eql [1,7]
    end
  end

end
