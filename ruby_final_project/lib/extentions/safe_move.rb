# frozen_string_literal: true

class SafeMove
  def initialize(position, board, moves, piece = board.table[position[0]][position[1]])
    @board = board
    @position = position
    @moves = moves
    @piece = piece
  end

  def safe?
    @board.table[@position[0]][@position[1]] = nil

    @moves.select do |move|
      @board.table[move[0]][move[1]] = @piece
      @piece.change_position(move[0], move[1])

      @board.table.flatten.compact.none? do |piece|
        next if piece.color == @piece.color

        piece.possible_captures(@board).include?(king_position)
      end
    end
  end

  private

  def king_position
    @piece.color == :white ? @board.white_king.position : @board.black_king.position
  end
end
