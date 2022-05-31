# frozen_string_literal: true

require_relative '../extentions/safe_move'

class Piece
  attr_reader :symbol, :color, :position, :current_moves, :current_captures, :moved

  def initialize(_board, data)
    @position = data[:position]
    @color = data[:color]
    @symbol = nil
    @current_moves = []
    @current_captures = []
    @moved = false
  end

  def possible_moves(board, table = board.table)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      while (0..7).include?(row) && (0..7).include?(column)
        break if table[row][column]

        possibilities.append([row, column])
        row    += move[0]
        column += move[1]
      end
    end

    possibilities
  end

  def possible_captures(board, table = board.table)
    possibilities = []

    moves.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      while (0..7).include?(row) && (0..7).include?(column)
        break if table[row][column]

        row    += move[0]
        column += move[1]
      end

      next unless (0..7).include?(row) && (0..7).include?(column)

      possibilities.append([row, column]) if enemy_piece?(table[row][column])
    end

    possibilities
  end

  def update(board)
    update_moves(board)
    update_captures(board)
  end

  def change_position(row, column)
    @position = [row, column]
    @moved = true
  end

  def white?
    @color == :white
  end

  private

  def update_moves(board)
    @current_moves = SafeMove.new(position, Marshal.load(Marshal.dump(board)), possible_moves(board)).safe?
  end

  def update_captures(board)
    @current_captures = SafeMove.new(position, Marshal.load(Marshal.dump(board)), possible_captures(board)).safe?
  end

  def enemy_piece?(piece)
    piece && piece.color != color
  end
end
