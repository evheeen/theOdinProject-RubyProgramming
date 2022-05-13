# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♚'
  end

  def possible_moves(board)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      next unless (0..7).include?(row) && (0..7).include?(column)
      next if board.table[row][column]

      possibilities.append([row, column])
    end

    possibilities
  end

  private

  def castling_moves
    
  end
  
  def moves
    [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
  end
end
