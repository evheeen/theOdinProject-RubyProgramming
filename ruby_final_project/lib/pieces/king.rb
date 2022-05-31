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

    possible_castling = castling?(board)
    possible_castling.map { |castling| possibilities.append(castling) } if possible_castling

    possibilities
  end

  def possible_captures(board)
    possibilities = []

    moves.each do |move|
      row    = move[0] + position[0]
      column = move[1] + position[1]

      next unless (0..7).include?(row) && (0..7).include?(column)

      possibilities.append([row, column]) if enemy_piece?(board.table[row][column])
    end

    possibilities
  end

  private

  def castling?(board)
    return false if moved

    castling_row_empty = castling_row_empty?(board)
    return false if castling_row_empty == [false, false]

    castling_through_check = castling_row_empty.map.with_index { |_side, index| castling_through_check?(board, index) }
    return false if castling_through_check == [true, true]
    return false if board.check?(color)

    possibilities = []

    possibilities.append([position[0], position[1] - 2]) if castling_row_empty[0] && !castling_through_check[0]
    possibilities.append([position[0], position[1] + 2]) if castling_row_empty[1] && !castling_through_check[1]

    possibilities
  end

  def castling_row_empty?(board)
    check = [true, true]
    if board.table[position[0]][0].instance_of?(Rook) && board.table[position[0]][0].moved == false
      (1..3).each { |i| check[0] = false if board.table[position[0]][i] }
    end
    if board.table[position[0]][7].instance_of?(Rook) && board.table[position[0]][7].moved == false
      (5..6).each { |i| check[1] = false if board.table[position[0]][i] }
    end

    check
  end

  def castling_through_check?(board, side)
    side.zero? ? side = -1 : side = 1
    check = false

    board.table.flatten(1).compact.each do |piece|
      next if piece.color == color

      check = true if piece.current_moves.include?([position[0], position[1] + side])
    end

    check
  end

  def moves
    [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
  end
end
