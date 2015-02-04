# Chess
# by Daniel Nedrud
# 12/28/2014

require_relative '../lib/board_and_pieces'
require 'yaml'

class Chess
  
  attr_accessor(:board,:pieces,:turn)
  
  def initialize
    @board = Chess_board.new
    @pieces = setup_pieces()
    @turn = 1
    @computer_ai = "off"
  end
  
  # This is the method the user should call to start a game of Chess.
  # It gives you the option of starting from scratch or loading a saved file.
  def start
    puts "\n\nWelcome to Chess!"
    puts "_________________"
    puts "Please enter \"play\" to start a new game or enter \"load\" to pick up an existing game."
    response = gets.chomp.downcase
    
    until response == "play" || response == "load"
      puts "Oops! Please enter \"play\" or \"load\"."
      response = gets.chomp.downcase
    end
    
    case response
    when "play"
      Chess.new.human_or_computer()
    when "load"
      puts "Please enter the name of your saved file."
      name = gets.chomp
      file = File.open("saves/#{name}.txt", "r")
      contents = file.read
      YAML::load(contents).load_human_or_computer()
    end
  end
  
  def human_or_computer
    puts "Would you like to play against a human or the computer?"
    puts "Please enter \"human\" or \"computer\"."
    response = gets.chomp.downcase
    
    until response == "human" || response == "computer"
      puts "Oops! Please enter \"human\" or \"computer\"."
      response = gets.chomp.downcase
    end
    
    case response
    when "human"
      play_human()
    when "computer"
      @computer_ai = "on"
      play_computer()
    end
  end
  
  def load_human_or_computer
    play_computer() if @computer_ai == "on"
    play_human() if @computer_ai == "off"
  end
  
  # This method starts human vs. human gameplay
  def play_human
    puts "\nMake a move by entering coordinates of piece and destination in this format:"
    puts "\"b2 to b4\""
    puts "Enter \"help\" at any time for further information."
    puts display_board()
    
    @exit = false
    until checkmate?("white") || checkmate?("black") || stalemate?("white") || stalemate?("black") || @exit == true
      color = @turn % 2 == 0 ? "black" : "white"
      
      puts "#{color.capitalize} is in check!" if check?(color,@pieces)
      
      puts "#{color.capitalize} moves."
      player_input(color)
    end
    
    if checkmate?("white") || checkmate?("black")
      puts "===================================="
      puts "Checkmate! #{color.capitalize} wins!"
      puts "===================================="
      puts display_board()
    elsif stalemate?("white") || stalemate?("black")
      puts "===================================="
      puts "Stalemate! No one wins!"
      puts "===================================="
      puts display_board()
    end
  end
  
  # This method starts human vs. computer gameplay
  def play_computer
    puts "\nMake a move by entering coordinates of piece and destination in this format:"
    puts "\"b2 to b4\""
    puts "Enter \"help\" at any time for further information."
    puts display_board()
    
    color = "white"
    computer_color = "black"
    
    @exit = false
    until checkmate?("white") || checkmate?("black") || stalemate?("white") || stalemate?("black") || @exit == true
      
      puts "You are in check!" if check?("white",@pieces)
      puts "Computer is in check!" if check?("black",@pieces)
      
      puts "Your move."
      player_input(color)  
      
      computer_moves = all_available_moves(computer_color)
      computer_move = computer_moves[rand(computer_moves.length + 1)]
      
      # This is where computer makes random move out of the all_available_moves method.
      # Conditional is to make sure player entered valid move and advanced turn.
      player_move(computer_color,computer_move) if @turn % 2 == 0
    end
    
    if checkmate?("white") || checkmate?("black")
      puts "===================================="
      puts "Checkmate! You win!" if checkmate?("black")
      puts "Checkmate! The computer beat you!" if checkmate?("white")
      puts "===================================="
      puts display_board()
    elsif stalemate?("white") || stalemate?("black")
      puts "===================================="
      puts "Stalemate! No one wins!"
      puts "===================================="
      puts display_board()
    end
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
  
  def player_input(color)
    input = gets.chomp
    
    case input
    when "help"
      help()
    when "castle left"
      castle_left(color)
    when "castle right"
      castle_right(color)
    when "save"
      puts "Please enter a name for your file."
      save(gets.chomp)
    when "exit"
      @exit = true
    else
      player_move(color,coordinates_to_arr(input))
    end
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
  
  def player_move(color,input)
    available_pieces = @pieces.select { |piece| piece.color == color }
    enemy_pieces = @pieces.select { |piece| piece.color != color }
    
    # checks that piece was selected and move available as well as formatting of input
    if all_available_moves(color).include?(input)
      piece_position = input[0].split("").map { |i| i.to_i }
      piece_destination = input[1].split("").map { |i| i.to_i }
      piece_selected = available_pieces.find { |piece| piece.position == piece_position }
      
      possible_taken_piece = enemy_pieces.find { |piece| piece.position == piece_destination }
      piece_selected.move(piece_destination,@pieces)
      
      # deletes enemy piece if space was enemy occupied
      @pieces.delete(possible_taken_piece) if possible_taken_piece
      
      puts display_board()
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
  
  def stalemate?(color)
    if !check?(color,@pieces) && all_available_moves(color).count == 0
      true
    else
      false
    end
  end
  
  def castle_left(color)
    king = @pieces.find { |piece| piece.class == King && piece.color == color && piece.moves == 0 }
    rook = @pieces.find { |piece| piece.class == Rook && piece.color == color && piece.moves == 0 && [[1,1],[8,1]].include?(piece.position) }
    
    enemy_nonpawn_pieces = @pieces.select { |piece| piece.color != color && piece.class != Pawn }
    enemy_pawns = @pieces.select { |piece| piece.color != color && piece.class == Pawn }
    
    if color == "white"
      piece_attacking = enemy_nonpawn_pieces.any? { |piece| piece.available_moves(@pieces).any? { |move| [[1,3],[1,4],[1,5]].include?(move) } }
      pawn_attacking = enemy_pawns.any? { |piece| [[2,2],[2,3],[2,4],[2,5],[2,6]].include?(piece.position) }
      occupied_spaces = @pieces.any? { |piece| [[1,2],[1,3],[1,4]].include?(piece.position) }
      if king && rook && !piece_attacking && !pawn_attacking && !occupied_spaces
        king.position = [1,3]
        rook.position = [1,4]
        puts display_board()
        @turn += 1
      else
        puts "You can not castle left at this time."
      end
    elsif color == "black"
      piece_attacking = enemy_nonpawn_pieces.any? { |piece| piece.available_moves(@pieces).any? { |move| [[8,3],[8,4],[8,5]].include?(move) } }
      pawn_attacking = enemy_pawns.any? { |piece| [[7,2],[7,3],[7,4],[7,5],[7,6]].include?(piece.position) }
      occupied_spaces = @pieces.any? { |piece| [[8,2],[8,3],[8,4]].include?(piece.position) }
      if king && rook && !piece_attacking && !pawn_attacking && !occupied_spaces
        king.position = [8,3]
        rook.position = [8,4]
        puts display_board()
        @turn += 1
      else
        puts "You can not castle left at this time."
      end
    end
  end
  
  def castle_right(color)
    king = @pieces.find { |piece| piece.class == King && piece.color == color && piece.moves == 0 }
    rook = @pieces.find { |piece| piece.class == Rook && piece.color == color && piece.moves == 0 && [[1,8],[8,8]].include?(piece.position) }
    
    enemy_nonpawn_pieces = @pieces.select { |piece| piece.color != color && piece.class != Pawn }
    enemy_pawns = @pieces.select { |piece| piece.color != color && piece.class == Pawn }
    
    if color == "white"
      piece_attacking = enemy_nonpawn_pieces.any? { |piece| piece.available_moves(@pieces).any? { |move| [[1,5],[1,6],[1,7]].include?(move) } }
      pawn_attacking = enemy_pawns.any? { |piece| [[2,4],[2,5],[2,6],[2,7],[2,8]].include?(piece.position) }
      occupied_spaces = @pieces.any? { |piece| [[1,6],[1,7]].include?(piece.position) }
      if king && rook && !piece_attacking && !pawn_attacking && !occupied_spaces
        king.position = [1,7]
        rook.position = [1,6]
        puts display_board()
        @turn += 1
      else
        puts "You can not castle right at this time."
      end
    elsif color == "black"
      piece_attacking = enemy_nonpawn_pieces.any? { |piece| piece.available_moves(@pieces).any? { |move| [[8,5],[8,6],[8,7]].include?(move) } }
      pawn_attacking = enemy_pawns.any? { |piece| [[7,4],[7,5],[7,6],[7,7],[7,8]].include?(piece.position) }
      occupied_spaces = @pieces.any? { |piece| [[8,6],[8,7]].include?(piece.position) }
      if king && rook && !piece_attacking && !pawn_attacking && !occupied_spaces
        king.position = [8,7]
        rook.position = [8,6]
        puts display_board()
        @turn += 1
      else
        puts "You can not castle right at this time."
      end
    end
  end
  
  private
  
  # Saves the player's current position in YAML format to a file of their choice in the folder "saves".
  def save(name)
    yaml = YAML::dump(self)
    file_name = "#{name}.txt"
    File.open("saves/" + file_name, "w") { |i| i.write(yaml) }
    puts "Game was saved as \"#{name}\""
  end
  
  def setup_pieces
    [Pawn.new([2,1],"white"),Pawn.new([2,2],"white"),Pawn.new([2,3],"white"),Pawn.new([2,4],"white")] +
    [Pawn.new([2,5],"white"),Pawn.new([2,6],"white"),Pawn.new([2,7],"white"),Pawn.new([2,8],"white")] +
    [Rook.new([1,1],"white"),Knight.new([1,2],"white"),Bishop.new([1,3],"white"),Queen.new([1,4],"white")] +
    [King.new([1,5],"white"),Bishop.new([1,6],"white"),Knight.new([1,7],"white"),Rook.new([1,8],"white")] +
    [Pawn.new([7,1],"black"),Pawn.new([7,2],"black"),Pawn.new([7,3],"black"),Pawn.new([7,4],"black")] +
    [Pawn.new([7,5],"black"),Pawn.new([7,6],"black"),Pawn.new([7,7],"black"),Pawn.new([7,8],"black")] +
    [Rook.new([8,1],"black"),Knight.new([8,2],"black"),Bishop.new([8,3],"black"),Queen.new([8,4],"black")] +
    [King.new([8,5],"black"),Bishop.new([8,6],"black"),Knight.new([8,7],"black"),Rook.new([8,8],"black")]
  end
  
  def help
    puts %Q{\nPlayer Help for Chess
_____________________
To move a piece to a chosen location
enter movement command like so \"d4 to e5\".
To castle enter either \"castle left\" or \"castle right\".
To save your game enter \"save\".
To exit a game midway through enter \"exit\".
}
  end
  
end

chess = Chess.new
chess.start

