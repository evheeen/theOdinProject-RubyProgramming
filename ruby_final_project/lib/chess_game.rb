# frozen_string_literal: true

require_relative 'board'

class ChessGame
  def initialize(board = Board.new, turn = :white)
    @board = board
    @turn = turn
  end

  def launch
    puts 'This is Chess game. Choose the action:'
    puts '1 - New Game'
    puts '2 - Load Game'
    puts "\nq - to exit"

    new_or_load
  end

  def game_party(loaded: false)
    @board.create_board unless loaded

    puts 'Type save to save progress.'

    loop do
      break if @board.game_over?(@turn)

      @board.show_board
      turn
      swap_players
    end

    @board.show_board
    puts 'Game Over'
  end

  private

  def turn
    @board.update
    puts "#{@turn.capitalize}'s turn"

    row, column = get_piece
    row, column = get_move(row, column)

    @board.update_piece(row, column)
  end

  def swap_players
    return @turn = :black if @turn == :white

    @turn = :white
  end

  def get_piece
    print 'Select the piece: '
    inputted = gets.chomp.strip
    exit if inputted == 'q'
    return save if inputted == 'save'

    validated = inputted_valid?(inputted.gsub(/[^1-8A-Ha-h]/, ''), :get)
    return get_piece unless validated
    return get_piece if @board.table[validated[0]][validated[1]].current_moves.empty? && @board.table[validated[0]][validated[1]].current_captures.empty?

    return validated[0], validated[1]
  end

  def get_move(row, column)
    @board.select_piece(row, column)
    return get_piece unless @board.selected_has_moves? || @board.selected_has_captures?

    @board.show_board
    print "\nEnter the move: "
    inputted = gets.chomp.strip.gsub(/[^1-8A-Ha-h]/, '')
    validated = inputted_valid?(inputted, :post)
    return get_move(row, column) unless validated

    return validated[0], validated[1]
  end

  def inputted_valid?(inputted, flag)
    return false if inputted.length != 2

    splitted = inputted.split('')

    return false unless splitted[0].match?(/[1-8]/)
    return false unless splitted[1].match?(/[A-Ha-h]/)

    row    = 8 - splitted[0].to_i
    column = splitted[1].downcase.ord - 97

    if flag == :get
      return false unless @board.piece_valid?(row, column, @turn)
    else
      return false unless @board.move_valid?(row, column)
    end

    [row, column]
  end

  def save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    
    file_name = request_file_name
    File.write("saves/#{file_name}", Marshal.dump(self))

    puts "Game saved\n\n"
    new_or_load
  end

  def request_file_name
    print 'Enter name for saved game: '
    file_name = gets.chomp.gsub(/[^0-9A-Za-z]/, '')

    unless file_name.length.positive?
      puts 'Invalid file name.'
      request_file_name
    end

    if Dir.glob('saves/*').map { |file| file.split('/')[1] }.include?("#{file_name}.json")
      puts "Game with name '#{file_name}' already exists. Rewrite (y/n)?"
      choose = gets.chomp

      return file_name if choose.downcase == 'y'
      return request_file_name if choose.downcase == 'n'
    else
      file_name
    end
  end

  def new_or_load
    inputted = gets.chomp.strip
    exit if inputted == 'q'

    return game_party if inputted == '1'
    return load_game if inputted == '2'

    puts 'Choose the action by number(1 or 2):'
    puts '1 - New Game'
    puts '2 - Load Game'

    new_or_load
  end

  def load_game
    unless Dir.exist?('saves')
      puts 'There are no saved games yet.'
      return new_or_load
    end

    puts 'Enter a file name from the list:'
    saved_games = Dir.glob('saves/*').map { |file| file.split('/')[1] }
    puts saved_games

    inputted = load_game_name(saved_games)

    game = File.open("saves/#{inputted}") { |file| Marshal.load(file) }
    # File.delete("saves/#{inputted}") if File.exist?("saves/#{inputted}")

    puts "\nGame loaded."
    game.game_party(loaded: true)
  end

  def load_game_name(saved_games)
    file_name = gets.chomp.gsub(/[^0-9A-Za-z]/, '')

    return file_name if saved_games.include?(file_name)

    load_game_name
  end
end

ChessGame.new.launch
