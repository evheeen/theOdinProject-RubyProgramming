# frozen_string_literal: true

require_relative 'board'

class ChessGame
  def initialize(board = Board.new, turn = :white)
    @board = board
    @turn = turn
  end

  def launch
    @board.create_board
    @board.show_board

    print @board.table[6][0].possible_moves(@board)
    puts
  end
end

ChessGame.new.launch
