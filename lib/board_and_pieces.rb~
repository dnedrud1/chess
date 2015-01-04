# These classes are for use in the program "Chess"
# by Daniel Nedrud
# 12/28/2014

# The chess board is just a two dimensional array of coordinates i.e. [1,1],[1,2]...
class Chess_board
  attr_accessor :squares

  def initialize
    @squares = []
    (1..8).each { |x| (1..8).each { |i| @squares.push([x,i]) } }
  end
end

# Pawn piece
class Pawn
  attr_accessor(:position,:color,:moves,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @moves = 0
    @symbol = @color == "white" ? "♙" : "♟"
  end
    
  def available_moves(pieces)  
    @color == "white" ? white_moves(pieces) : black_moves(pieces)
  end  
  
  # Pawn is only piece that moves in different direction depending on color
  # which is why two methods are necessary.
  def white_moves(pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
    
    all_checked = []
    [[row + 1,column - 1],[row + 1,column + 1]].each do |square| 
      if piece_positions.include?(square)
        occupying_piece = pieces.find { |piece| piece.position == square }
        all_checked.push(square) if occupying_piece.color != @color
      end
    end
    if !piece_positions.include?([row + 1, column])
      all_checked.push([row + 1, column])
      all_checked.push([row + 2, column]) if !piece_positions.include?([row + 2, column]) && @moves == 0
    end
    all_checked
  end
  
  def black_moves(pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
    
    all_checked = []
    [[row - 1,column - 1],[row - 1,column + 1]].each do |square| 
      if piece_positions.include?(square)
        occupying_piece = pieces.find { |piece| piece.position == square }
        all_checked.push(square) if occupying_piece.color != @color
      end
    end
    if !piece_positions.include?([row - 1, column])
      all_checked.push([row - 1, column])
      all_checked.push([row - 2, column]) if !piece_positions.include?([row - 2, column]) && @moves == 0
    end
    all_checked
  end
  
  def move(new,pieces)
    if available_moves(pieces).include?(new)
		  @position = new
		  @moves += 1
	  end
  end
end

# Knight piece
class Knight
  attr_accessor(:position,:color,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @symbol = @color == "white" ? "♘" : "♞"
  end
  
  def available_moves(pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
    
    all_unchecked = [[row + 2,column + 1], [row + 2,column - 1], [row - 2,column + 1], [row - 2,column - 1], [row + 1,column + 2], [row - 1,column + 2], [row + 1,column - 2], [row - 1,column - 2]]
    all_checked = []
    all_unchecked.each do |square|
      if board.include?(square)
        if !piece_positions.include?(square)
          all_checked.push(square)
        else
          occupying_piece = pieces.find { |piece| piece.position == square }
          if occupying_piece.color != @color
            all_checked.push(square)
          end
        end
      end
    end
    all_checked
  end  
  
  def move(new,pieces)
    @position = new if available_moves(pieces).include?(new)
  end
end

# Bishop piece
class Bishop
  attr_accessor(:position,:color,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @symbol = @color == "white" ? "♗" : "♝"
  end
  
  def available_moves(pieces)  
    all_diagonals = []
    [[1,1],[-1,-1],[-1,1],[1,-1]].each do |direction|
      all_diagonals += diagonals(direction,pieces)
    end
    all_diagonals
  end
  
  def diagonals(arr,pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
   
    all_checked = []
    condition = false
    until condition == true
      current = [row + arr[0], column + arr[1]]
      if board.include?(current)
		    if !piece_positions.include?(current)
		      all_checked.push(current)
		    else
		      occupying_piece = pieces.find { |piece| piece.position == current }
		      all_checked.push(current) if occupying_piece.color != @color
		      condition = true
		    end
	    else
	      condition = true
	    end
      row += arr[0]
      column += arr[1]
    end
    all_checked
  end
  
  def move(new,pieces)
    @position = new if available_moves(pieces).include?(new)
  end
end

# Rook piece
class Rook
  attr_accessor(:position,:color,:moves,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @moves = 0
    @symbol = @color == "white" ? "♖" : "♜"
  end
  
  def available_moves(pieces)  
    all_lines = []
    [[0,1],[0,-1],[-1,0],[1,0]].each do |direction|
      all_lines += lines(direction,pieces)
    end
    all_lines
  end
  
  def lines(arr,pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
   
    all_checked = []
    condition = false
    until condition == true
      current = [row + arr[0], column + arr[1]]
      if board.include?(current)
		    if !piece_positions.include?(current)
		      all_checked.push(current)
		    else
		      occupying_piece = pieces.find { |piece| piece.position == current }
		      all_checked.push(current) if occupying_piece.color != @color
		      condition = true
		    end
	    else
	      condition = true
	    end
      row += arr[0]
      column += arr[1]
    end
    all_checked
  end
  
  def move(new,pieces)
    if available_moves(pieces).include?(new)
		  @position = new
		  @moves += 1
	  end
  end
end

# Queen piece
class Queen
  attr_accessor(:position,:color,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @symbol = @color == "white" ? "♕" : "♛"
  end
  
  def available_moves(pieces)  
    all_lines_and_diagonals = []
    [[1,1],[-1,-1],[-1,1],[1,-1],[0,1],[0,-1],[-1,0],[1,0]].each do |direction|
      all_lines_and_diagonals += lines_or_diagonals(direction,pieces)
    end
    all_lines_and_diagonals
  end
  
  def lines_or_diagonals(arr,pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
   
    all_checked = []
    condition = false
    until condition == true
      current = [row + arr[0], column + arr[1]]
      if board.include?(current)
		    if !piece_positions.include?(current)
		      all_checked.push(current)
		    else
		      occupying_piece = pieces.find { |piece| piece.position == current }
		      all_checked.push(current) if occupying_piece.color != @color
		      condition = true
		    end
	    else
	      condition = true
	    end
      row += arr[0]
      column += arr[1]
    end
    all_checked
  end
  
  def move(new,pieces)
    @position = new if available_moves(pieces).include?(new)
  end
end

# King piece
class King
  attr_accessor(:position,:color,:moves,:symbol)

  def initialize(position,color)
    @position = position
    @color = color
    @moves = 0
    @symbol = @color == "white" ? "♔" : "♚"
  end
  
  # Allows King to be included when checking if oppoponent's King is moving into check.
  def unchecked_moves
    row = @position[0]
    column = @position[1]
    [[row + 1,column + 1],[row - 1,column - 1],[row - 1,column + 1],[row + 1,column - 1],[row,column + 1],[row,column - 1],[row - 1,column],[row + 1,column]]
  end
  
  def available_moves(pieces)  
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
    
    all_unchecked = [[row + 1,column + 1],[row - 1,column - 1],[row - 1,column + 1],[row + 1,column - 1],[row,column + 1],[row,column - 1],[row - 1,column],[row + 1,column]]
    all_checked = []
    all_unchecked.each do |square|
      if board.include?(square)
        if !piece_positions.include?(square)
          all_checked.push(square)
        else
          occupying_piece = pieces.find { |piece| piece.position == square }
          if occupying_piece.color != @color
            all_checked.push(square)
          end
        end
      end
    end
    all_checked
  end
  
  def move(new,pieces)
    if available_moves(pieces).include?(new)
		  @position = new
		  @moves += 1
	  end
  end
end

