# frozen_string_literal: true

require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

class Board
  attr_reader :white_king, :black_king
  attr_accessor :table, :selected, :previous

  def initialize(table = Array.new(8) { Array.new(8) }, data = {})
    @table = table
    @selected = data[:selected]
    @previous = data[:previous]
    @white_king = data[:white_king]
    @black_king = data[:black_king]
  end

  def create_board
    fill_pawn(1, :black)
    fill_pawn(6, :white)
    fill_first_row(0, :black)
    fill_first_row(7, :white)

    @white_king = @table[7][4]
    @black_king = @table[0][4]

    update
  end

  def show_board
    puts '   a  b  c  d  e  f  g  h '

    table.each_with_index do |row, row_index|
      print "#{8 - row_index} "
      row.each_with_index do |column, column_index|
        if column
          if column == @selected
            print "\e[48;5;#{selected_background_color(row_index, column_index)}m \e[38;5;#{piece_color(column)};1m#{column.symbol} "
          elsif @selected&.current_captures.include?([row_index, column_index])
            print "\e[48;5;1m \e[38;5;#{piece_color(column)};1m#{column.symbol} "
          else
            print "\e[48;5;#{background_color(row_index, column_index)}m \e[38;5;#{piece_color(column)};1m#{column.symbol} "
          end
        elsif @selected && (@selected.current_moves.include?([row_index, column_index]) || @selected.current_captures.include?([row_index, column_index]))
          print "\e[48;5;#{background_color(row_index, column_index)}m \e[38;5;#{piece_color(@selected)};1m○ "
        else
          print "\e[48;5;#{background_color(row_index, column_index)}m   "
        end
      end

      puts "\e[0m #{8 - row_index} "
    end

    puts '   a  b  c  d  e  f  g  h '
  end

  def update
    table.flatten.compact.each { |piece| piece.update(self) }
  end

  def update_piece(row, column)
    return en_passant(row, column) if en_passant?(row, column)
    return castling(row, column) if castling?(column)

    @table[row][column] = @selected
    selected_position = @selected.position
    @table[selected_position[0]][selected_position[1]] = nil
    @selected.change_position(row, column)

    promotion(row, column) if @selected.instance_of?(Pawn) && promotion?(row)

    @previous = @selected
    @selected = nil
  end

  def check?(color)
    king = color == :white ? @white_king : @black_king

    table.flatten.compact.each { |piece| return true if piece.current_captures.include?(king.position) }

    false
  end

  def game_over?(color)
    @table.flatten.compact.each do |piece|
      next if piece.color != color

      return false if piece.current_moves.size.positive? || piece.current_captures.size.positive?
    end

    true
  end

  def piece_valid?(row, column, color)
    table[row][column]&.color == color
  end

  def move_valid?(row, column)
    return false unless @selected.current_moves.include?([row, column]) || @selected.current_captures.include?([row, column])

    true
  end

  def select_piece(row, column)
    @selected = table[row][column]
  end

  def selected_has_moves?
    @selected.current_moves.positive?
  end

  def selected_has_captures?
    @selected.current_captures.positive?
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
                  Knight.new(self, { position: [row, 5], color: color }),
                  Bishop.new(self, { position: [row, 6], color: color }),
                  Rook.new(self, { position: [row, 7], color: color })]
  end

  def piece_color(piece)
    piece.white? ? 15 : 0
  end

  def background_color(row, column)
    (row + column).even? ? 250 : 245
  end

  def selected_background_color(row, column)
    (row + column).even? ? 248 : 240
  end

  def en_passant?(row, column)
    return false unless @previous&.position
    return false unless @selected.instance_of?(Pawn) && @previous.instance_of?(Pawn)
    return false unless (@selected.position[0] == 3 && @selected.color == :white) || (@selected.position[0] == 4 && @selected.color == :black)
    return false unless @previous.position[0] == row && (@previous.position[0] - column).abs == 1

    true
  end

  def en_passant(row, column)
    @table[row][column] = @selected
    selected_position = @selected.position
    @table[selected_position[0]][selected_position[1]] = nil
    @table[selected_position[0]][column] = nil
    @selected.change_position(row, column)

    @previous = @selected
    @selected = nil
  end

  def promotion?(row)
    (row.zero? && @selected.color == :white) || (row == 7 && @selected.color == :black)
  end

  def promotion(row, column)
    print 'Choose new piece(1 - Rook, 2 - Knight, 3 - Bishop, 4 - Queen): '
    inputted = gets.chomp.strip.gsub(/[^1-4]/, '')

    return promotion(row, column) if inputted.length != 1

    case inputted.to_i
    when 1
      @table[row][column] = Rook.new(self, { position: [row, column], color: @selected.color })
    when 2
      @table[row][column] = Knight.new(self, { position: [row, column], color: @selected.color })
    when 3
      @table[row][column] = Bishop.new(self, { position: [row, column], color: @selected.color })
    when 4
      @table[row][column] = Queen.new(self, { position: [row, column], color: @selected.color })
    end
  end

  def castling?(column)
    return false unless @selected.instance_of?(King)

    (@selected.position[1] - column).abs == 2
  end

  def castling(row, column)
    @table[row][column] = @selected
    selected_position = @selected.position
    @table[selected_position[0]][selected_position[1]] = nil
    @selected.change_position(row, column)

    if selected_position[1] > column
      table[row][column + 1] = table[row][0]
      table[row][0] = nil
    else
      table[row][column - 1] = table[row][7]
      table[row][7] = nil
    end

    @previous = @selected
    @selected = nil
  end
end
