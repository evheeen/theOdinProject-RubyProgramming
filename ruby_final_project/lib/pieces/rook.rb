# frozen_string_literal: true

require_relative 'piece'

class Rook < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♜'
  end

  private

  def moves
    [[1, 0], [0, -1], [0, 1], [-1, 0]]
  end
end
