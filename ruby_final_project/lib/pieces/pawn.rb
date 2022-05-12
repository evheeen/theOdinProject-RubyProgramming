# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♟'
  end

  private

  def moves 
    [[1, 0]]
  end
end
