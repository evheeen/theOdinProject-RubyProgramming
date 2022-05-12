# frozen_string_literal: true

require_relative 'piece'

class Queen < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♛'
  end

  private

  def moves
    [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
  end
end
