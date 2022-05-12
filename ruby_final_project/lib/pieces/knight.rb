# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♞'
  end

  def possible_moves(board)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      next unless (0..7).include?(row) && (0..7).include?(column)

      possibilities.append([row, column]) 
    end

    possibilities
  end

  private

  def moves
    [[2, 1], [1, 2], [2, -1], [1, -2], [-2, 1], [-1, 2], [-2, -1], [-1, -2]]
  end
end
