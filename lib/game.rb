# Chess
# by Daniel Nedrud
# 12/28/2014

require_relative '../lib/board_and_pieces'

class Chess
  
  attr_accessor(:board,:pieces,:white_pieces,:black_pieces)
  
  def initialize
    @board = Chess_board.new
    @pieces = setup_pieces()
    @turn = 1
  end
  
  def start
    puts "Welcome to a game of Chess!"
    puts "---------------------------"
    puts "Make a move by entering coordinates of piece and destination in this format:"
    puts "row,column to row,column"
    puts "e.g. 2,3 to 2,5"
    puts "Enter \"help\" at any time for further information"
    
  	until victory?("white") || victory?("black")
  	  color = @turn % 2 == 0 ? "black" : "white"
  	  
			puts display_board()
			puts "#{color.capitalize} moves."
      player_move(color)
		end
	end
	
	def player_move(color)
	  available_pieces = @pieces.select { |i| i.color == color }
	  enemy_pieces = @pieces.select { |i| i.color != color }
	  
	  input = gets.chomp
	  input_array = input.split(" ")
	  
	  # checks basic formatting of input
	  if input_array.length == 3 && input_array[1] == "to"
			piece_position = input_array[0].split(",").map { |i| i.to_i }
			piece_destination = input_array[2].split(",").map { |i| i.to_i }
			piece_selected = available_pieces.find { |piece| piece.position == piece_position }
			
			# checks that piece was actually selected
			if piece_selected
			
			  # checks that move is valid
			  if piece_selected.available_moves(@pieces).include?(piece_destination)
			    possible_taken_piece = enemy_pieces.find { |piece| piece.position == piece_destination }
			    piece_selected.move(piece_destination,@pieces)
			    
			    # deletes enemy piece if space was enemy occupied
			    if possible_taken_piece
			      @pieces.delete(possible_taken_piece)
			    end
			    
			    @turn += 1
			  else
			  	puts "Please enter a valid move!"
	        puts "e.g. \"2,3 to 2,5\""
        end
			else
				puts "Please enter a valid move!"
			  puts "e.g. \"2,3 to 2,5\""
			end
		else
		  puts "Please enter a valid move!"
	    puts "e.g. \"2,3 to 2,5\""
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
    "  1 2 3 4 5 6 7 8\n" + board_rows.map { |row| (number -= 1).to_s + " " + row.join(" ") }.join("\n")
  end
  
  def victory?(color)
    false
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

#chess = Chess.new
#chess.start
