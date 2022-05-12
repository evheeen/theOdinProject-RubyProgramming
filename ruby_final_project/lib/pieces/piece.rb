# frozen_string_literal: true

class Piece
  attr_reader :symbol, :color, :position

  def initialize(board, data)
    board.add_observer(self)
    @position = data[:position]
    @color = data[:color]
    @symbol = nil
  end

  def possible_moves(board, table = board.table)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      while (0..7).include?(row) && (0..7).include?(column)
        break if table[row][column]

        possibilities.append([row, column])
        row    += 1
        column += 1
      end
    end

    possibilities
  end

  def update
    
  end

  def change_position(row, column)
    @position = [row, column]
  end

  def white?
    @color == :white
  end

  private

  def method_name
    
  end
end
