# frozen_string_literal: true

class KnightsTravails
  attr_reader :position, :previous, :steps

  MOVES = [[2, 1], [1, 2], [2, -1], [1, -2], [-2, 1], [-1, 2], [-2, -1], [-1, -2]].freeze

  def initialize(position, previous)
    @position = position
    @previous = previous
    @steps = 0
  end

  def knight_moves
    moves = []

    MOVES.each do |move|
      row    = move[0] + @position[0]
      column = move[1] + @position[1]

      moves.append([row, column]) if (0..7).include?(row) && (0..7).include?(column)
    end

    moves.map { |move| KnightsTravails.new(move, self) }
  end

  def path(move)
    path(move.previous) if move.previous

    print move.position, ' -> '
    @steps += 1
  end
end

def knight_moves(position, target)
  position.each { |i| return unless (0..7).include?(i) }
  target.each { |i| return unless (0..7).include?(i) }

  knights_travails = KnightsTravails.new(position, nil)
  queue = []
  loop do
    break if knights_travails.position == target

    knights_travails.knight_moves.each { |knight_move| queue.push(knight_move) }
    knights_travails = queue.shift
  end

  knights_travails.path(knights_travails)
  print knights_travails.steps, " steps\n"
end

knight_moves([0, 0], [7, 7])
# => [0, 0] -> [2, 1] -> [4, 2] -> [6, 3] -> [7, 5] -> [5, 6] -> [7, 7] -> 7 steps
knight_moves([0, 0], [1, 1])
# => [0, 0] -> [2, 1] -> [4, 2] -> [2, 3] -> [1, 1] -> 5 steps
