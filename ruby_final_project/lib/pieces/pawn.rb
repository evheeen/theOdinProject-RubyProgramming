# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♟'
  end

  def possible_moves(board)
    possibilities = []

    row    = moves[0][0] + @position[0]
    column = moves[0][1] + @position[1]

    2.times do 
      break unless (0..7).include?(row) && (0..7).include?(column)
      break if board.table[row][column]

      possibilities.append([row, column])

      break if @moved

      row    += moves[0][0]
      column += moves[0][1]
    end

    possibilities
  end

  private

  def moves 
    return [[-1, 0]] if white?

    [[1, 0]]
  end
end
