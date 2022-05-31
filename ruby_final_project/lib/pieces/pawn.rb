# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  def initialize(board, data)
    super(board, data)
    @symbol = '♟'
  end

  def possible_moves(board)
    possibilities = []

    row    = moves[0][0] + position[0]
    column = moves[0][1] + position[1]

    2.times do
      break unless (0..7).include?(row) && (0..7).include?(column)
      break if board.table[row][column]

      possibilities.append([row, column])

      break if moved

      row    += moves[0][0]
      column += moves[0][1]
    end

    possibilities
  end

  def possible_captures(board)
    possibilities = []

    possible_capture = board.table[position[0] + moves[0][0]][position[1] - 1]
    possibilities.append([position[0] + moves[0][0], position[1] - 1]) if enemy_piece?(possible_capture)

    possible_capture = board.table[position[0] + moves[0][0]][position[1] + 1]
    possibilities.append([position[0] + moves[0][0], position[1] + 1]) if enemy_piece?(possible_capture)

    possible_capture = en_passant?(board)
    possibilities.append(possible_capture) if possible_capture

    possibilities
  end

  def change_position(row, column)
    @position = [row, column]
    @moved = true
  end

  private

  def en_passant?(board)
    return false unless board.previous&.position
    return false unless (board.previous.position[1] - position[1]).abs == 1
    return false unless (position[0] == 3 && color == :white) || (position[0] == 4 && color == :black)
    return false unless symbol == board.previous.symbol

    return [position[0] + moves[0][0], board.previous.position[1]]
  end

  def moves
    return [[-1, 0]] if white?

    [[1, 0]]
  end
end
