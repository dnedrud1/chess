class Chess_board
  attr_accessor :squares

  def initialize
    @squares = []
    (1..8).each { |x| (1..8).each { |i| @squares.push([x,i]) } }
  end
end

class Pawn
  attr_accessor(:position,:color)

  def initialize(position,color)
    @position = position
    @color = color
  end
    
  def available_moves(pieces)
    board = Chess_board.new.squares
    piece_positions = pieces.map { |piece| piece.position }
    row = @position[0]
    column = @position[1]
    
    all_checked = []
  end  
  
  def move(new,pieces)
    @position = new if available_moves(pieces).include?(new)
  end
end

class Knight
  attr_accessor(:position,:color)

  def initialize(position,color)
    @position = position
    @color = color
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

class Bishop
  attr_accessor :position

  def initialize(position)
    @position = position
  end
end

class Rook
  attr_accessor :position

  def initialize(position)
    @position = position
  end
end

class Queen
  attr_accessor :position

  def initialize(position)
    @position = position
  end
end

class King
  attr_accessor :position

  def initialize(position)
    @position = position
  end
end

