# frozen_string_literal: true

require_relative 'piece'

class Bishop < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♝'
  end

  private

  def moves
    [[1, -1], [1, 1], [-1, -1], [-1, 1]]
  end
end
