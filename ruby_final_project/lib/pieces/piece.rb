# frozen_string_literal: true

class Piece
  attr_reader :symbol, :color, :position, :current_moves

  def initialize(board, data)
    board.add_observer(self)
    @position = data[:position]
    @color = data[:color]
    @symbol = nil
    @current_moves = []
    @moved = false
  end

  def possible_moves(board, table = board.table)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      while (0..7).include?(row) && (0..7).include?(column)
        break if table[row][column]

        possibilities.append([row, column])
        row    += move[0]
        column += move[1]
      end
    end

    possibilities
  end

  def update(board)
    update_moves(board)
  end

  def change_position(row, column)
    @position = [row, column]
    @moved = true
  end

  def white?
    @color == :white
  end

  private

  def update_moves(board)
    @current_moves = possible_moves(board)
  end
end
