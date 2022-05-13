# frozen_string_literal: true

require_relative 'board'

class ChessGame
  def initialize(board = Board.new, turn = :white)
    @board = board
    @turn = turn
  end

  def launch
    @board.create_board

    loop do
      break if @board.game_over?

      @board.show_board
      turn
    end
  end

  private

  def turn
    puts "#{@turn}'s turn"

    piece = get_piece
    move  = get_move(piece)

    swap_players
  end

  def swap_players
    @turn == :white ? :black : :white
  end

  def get_piece
    print "Select the piece: "
    inputted = gets.chomp.strip.gsub(/[^1-8A-Ha-h]/, '')

    validated = inputted_valid?(inputted)
    return get_piece unless validated

    validated
  end

  def get_move(piece)
    @board.select_piece(piece)
    return get_piece unless selected_has_moves?
  end

  def inputted_valid?(inputted)
    return false if inputted.length > 2

    splited = inputted.split()

    return false unless splited[0].match(/[^1-8]/)
    return false unless splited[1].match(/[^A-Ha-h]/)

    row    = 8 - splited[0].to_i
    column = splited[1].downcase.ord - 97

    return false unless @board.piece_valid?(row, column, @turn)

    [row, column]
  end
end

ChessGame.new.launch
