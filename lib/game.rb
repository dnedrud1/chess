# Chess
# by Daniel Nedrud
# 12/28/2014

require_relative '../lib/board_and_pieces'

class Chess
  
  attr_accessor(:board,:pieces,:turn)
  
  def initialize
    @board = Chess_board.new
    @pieces = setup_pieces()
    @turn = 1
  end
  
  def start
    puts "Welcome to a game of Chess!"
    puts "---------------------------"
    puts "Make a move by entering coordinates of piece and destination in this format:"
    puts "ColumnRow to ColumnRow"
    puts "e.g. \"b2 to b4\""
    puts "Enter \"help\" at any time for further information"
    
  	until checkmate?("white") || checkmate?("black")
  	  color = @turn % 2 == 0 ? "black" : "white"
  	  
  	  puts "#{color.capitalize} is in check!" if check?(color,@pieces)
  	  
			puts display_board()
			puts "#{color.capitalize} moves."
      player_move(color)
		end
		
		puts "Checkmate! #{color.capitalize} wins!"
		puts display_board()
		
	end
	
	# duplicates board and returns array of all possible moves formatted as proper text input
	def all_available_moves(color)
    piece_placeholders = @pieces.map { |piece| piece.dup }
		player_pieces = piece_placeholders.select { |piece| piece.color == color }
		
    all_moves = []
	  player_pieces.each do |player_piece|
	    player_piece.available_moves(piece_placeholders).each do |move|
	      # selects piece to move and captured piece if one exists
	      position_placeholder = player_piece.position.dup
	      captured_placeholder = piece_placeholders.find { |piece| piece.position == move }
	      
	      # moves piece and deletes captured piece if one exists
	      piece_placeholders.delete(captured_placeholder) if captured_placeholder
	      player_piece.move(move,piece_placeholders)
	      
	      # adds move to array if it is valid
	      all_moves.push(["#{position_placeholder.join("")}","#{move.join("")}"]) if !check?(color,piece_placeholders)
	      
	      # resets pieces
	      piece_placeholders += [captured_placeholder] if captured_placeholder
	      player_piece.position = position_placeholder
	    end
    end
    all_moves
	end
	
	def coordinates_to_arr(input)
	  key = {"a" => "1", "b" => "2", "c" => "3", "d" => "4", "e" => "5", "f" => "6", "g" => "7", "h" => "8"}
	  input_arr = input.split(" ")
	  if input_arr.length == 3 && input_arr[0].length == 2 && input_arr[2].length == 2
	    position = input_arr[0].split("")
	    destination = input_arr[2].split("")
	    ["#{position[1]}#{key[position[0]]}","#{destination[1]}#{key[destination[0]]}"]
    else
      "invalid input"
    end
	end
	
	def player_move(color)
	  available_pieces = @pieces.select { |i| i.color == color }
	  enemy_pieces = @pieces.select { |i| i.color != color }
	  
	  input_array = coordinates_to_arr(gets.chomp)
	  
	  # checks that piece was selected and move available as well as formatting of input
	  if all_available_moves(color).include?(input_array)
			piece_position = input_array[0].split("").map { |i| i.to_i }
			piece_destination = input_array[1].split("").map { |i| i.to_i }
			piece_selected = available_pieces.find { |piece| piece.position == piece_position }
			
	    possible_taken_piece = enemy_pieces.find { |piece| piece.position == piece_destination }
	    piece_selected.move(piece_destination,@pieces)
	    
	    # deletes enemy piece if space was enemy occupied
	    @pieces.delete(possible_taken_piece) if possible_taken_piece
	    
	    @turn += 1
		else
		  puts "Please enter a valid move!\ne.g. \"b2 to b4\""
    end
	end
  
  def display_board
    board_with_pieces = []
    piece_positions = @pieces.map { |piece| piece.position }
    @board.squares.each do |square|
      if !piece_positions.include?(square)
        board_with_pieces.push("_")
      else
        occupying_piece = pieces.find { |piece| piece.position == square }
        board_with_pieces.push(occupying_piece.symbol)
      end
    end
    board_rows = board_with_pieces.each_slice(8).to_a.reverse
    number = 9
    "  a b c d e f g h\n" + board_rows.map { |row| (number -= 1).to_s + " " + row.join(" ") }.join("\n")
  end
  
  def check?(color,pieces)
	  king = pieces.find { |piece| piece.color == color && piece.class == King }
	  enemy_pieces = pieces.select { |i| i.color != color }
	  enemy_moves = enemy_pieces.inject([]) { |sum,piece| sum + piece.available_moves(pieces) }
		
		if king
			if enemy_moves.any? { |move| move == king.position }
				true
			else
				false
			end
		else
		  false
		end
	end 
	
  def checkmate?(color)
		if check?(color,@pieces) && all_available_moves(color).count == 0
		  true
	  else
      false
		end
  end
  
  private
  
  def setup_pieces
    [Pawn.new([2,1],"white"),Pawn.new([2,2],"white"),Pawn.new([2,3],"white"),Pawn.new([2,4],"white")] +
    [Pawn.new([2,5],"white"),Pawn.new([2,6],"white"),Pawn.new([2,7],"white"),Pawn.new([2,8],"white")] +
    [Rook.new([1,1],"white"),Knight.new([1,2],"white"),Bishop.new([1,3],"white"),King.new([1,4],"white")] +
    [Queen.new([1,5],"white"),Bishop.new([1,6],"white"),Knight.new([1,7],"white"),Rook.new([1,8],"white")] +
    [Pawn.new([7,1],"black"),Pawn.new([7,2],"black"),Pawn.new([7,3],"black"),Pawn.new([7,4],"black")] +
    [Pawn.new([7,5],"black"),Pawn.new([7,6],"black"),Pawn.new([7,7],"black"),Pawn.new([7,8],"black")] +
    [Rook.new([8,1],"black"),Knight.new([8,2],"black"),Bishop.new([8,3],"black"),King.new([8,4],"black")] +
    [Queen.new([8,5],"black"),Bishop.new([8,6],"black"),Knight.new([8,7],"black"),Rook.new([8,8],"black")]
  end
  
end

chess = Chess.new
#chess.start

