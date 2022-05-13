# frozen_string_literal: true

require 'observer'
require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

class Board
  include Observable
  
  attr_accessor :table

  def initialize(table = Array.new(8) { Array.new(8) }, data = {})
    @table = table
    @selected = data[:selected]
  end

  def create_board
    fill_pawn(1, :black)
    fill_pawn(6, :white)
    fill_first_row(0, :black)
    fill_first_row(7, :white)
    update
  end

  def show_board
    puts "   a  b  c  d  e  f  g  h "

    table.each_with_index do |row, row_index|
      print "#{8 - row_index} "
      row.each_with_index do |column, column_index|
        if column
          print "\e[48;5;#{background_color(row_index, column_index)}m \e[38;5;#{piece_color(column)};1m#{column.symbol} "
        else
          print "\e[48;5;#{background_color(row_index, column_index)}m   "
        end
      end

      puts "\e[0m #{8 - row_index} "
    end

    puts "   a  b  c  d  e  f  g  h "
  end

  def update
    table.flatten.compact.each { |piece| piece.update(self) }
  end

  def game_over?
    false
  end

  def piece_valid?(row, column, color)
    table[row][column]&.color == color
  end

  def select_piece(row, column)
    @selected = table[row][column]
  end

  def selected_has_moves?
    @selected.possible_moves(@board).length > 0
  end

  private

  def fill_pawn(row, color)
    8.times do |column|
      table[row][column] = Pawn.new(self, { position: [row, column], color: color })
    end
  end

  def fill_first_row(row, color)
    table[row] = [Rook.new(self, { position: [row, 0], color: color }),
                  Knight.new(self, { position: [row, 1], color: color }),
                  Bishop.new(self, { position: [row, 2], color: color }),
                  Queen.new(self, { position: [row, 3], color: color }),
                  King.new(self, { position: [row, 4], color: color }),
                  Knight.new(self, { position: [row, 6], color: color }),
                  Bishop.new(self, { position: [row, 5], color: color }),
                  Rook.new(self, { position: [row, 7], color: color }),
    ]
  end

  def piece_color(piece)
    piece.white? ? 230 : 0
  end

  def background_color(row, column)
    (row + column).even? ? 250 : 245
  end
end
