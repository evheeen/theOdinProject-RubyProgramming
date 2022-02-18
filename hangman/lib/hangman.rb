# frozen_string_literal: true

require 'json'

class Hangman
  def initialize
    @secret_word = nil
    @secret_word_letters = ''
    @turn = 0
    @used_letters = []
  end

  def launch
    puts 'This is Hangman game. Choose the action:'
    puts '1 - New Game'
    puts '2 - Load Game'
    puts "\nq - to exit"

    new_or_load
  end

  private

  def game_party(loaded: false)
    unless loaded
      create_key

      @used_letters = []
      @turn = 1

      puts 'Computer has already created a secret word.'
    end

    loop do
      break if @turn == 9

      puts @secret_word_letters.chars.join(' '), "\n"
      puts "Used letters: #{@used_letters.join(' ')}" unless @used_letters.empty?
      print "Try [#{@turn}/8]. Enter a letter, or type save to save progress: "
      inputted = validate_inputted

      break save if inputted == 'save'

      @used_letters.append(inputted) unless @used_letters.include?(inputted)
      @turn += 1 unless solved?(inputted)

      return victory_message if game_over?
    end

    puts "You didn't guess the secret word.\n" unless game_over?
    new_or_load
  end

  def solved?(letter)
    if @secret_word.include?(letter)
      @secret_word.chars.each_with_index do |char, index|
        @secret_word_letters[index] = letter if char == letter
      end

      true
    else
      puts "Letter '#{letter}' not in word."

      false
    end
  end

  def game_over?
    @secret_word == @secret_word_letters
  end

  def victory_message
    puts "\nYou won! Secret word was #{@secret_word}.\n\n"
  end

  def validate_inputted
    inputted = gets.chomp.strip
    return 'save' if inputted == 'save'

    unless /[[:alpha:]]/.match(inputted) && inputted.length == 1
      print 'Invalid input. Enter alphabet letter: '
      validate_inputted
    end

    if @used_letters.include?(inputted)
      print 'This letter already used. Enter another letter: '
      validate_inputted
    end

    inputted.downcase
  end

  def create_key
    file = File.readlines('google-10000-english-no-swears.txt')
    words = []

    file.each do |line|
      words.append(line.chomp) if line.chomp.length >= 5 && line.chomp.length <= 12
    end

    @secret_word = words.sample
    @secret_word_letters = '_' * @secret_word.length
  end

  def new_or_load
    inputted = gets.chomp.strip
    return if inputted == 'q'

    return game_party if inputted == '1'
    return load_game if inputted == '2'

    puts 'Choose the action by number(1 or 2):'
    puts '1 - New Game'
    puts '2 - Load Game'

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

  def save
    Dir.mkdir('saves') unless Dir.exist?('saves')

    file_name = request_file_name
    File.write("saves/#{file_name}.json", JSON.dump({
      secret_word:     @secret_word,
      guessed_letters: @secret_word_letters,
      used_letters:    @used_letters,
      turn:            @turn
    }))

    puts "Game saved\n\n"
    new_or_load
  end

  def load_game_name(saved_games)
    file_name = gets.chomp.gsub(/[^0-9A-Za-z]/, '')

    return file_name if saved_games.include?(file_name)

    load_game_name
  end

  def load_game
    unless Dir.exist?('saves')
      puts 'There are no saved games yet.'
      return new_or_load
    end

    puts 'Enter a file name from the list:'
    saved_games = Dir.glob('saves/*').map { |file| file.split('/')[1].sub('.json', '') }
    puts saved_games

    inputted = load_game_name(saved_games)

    game_data = JSON.parse(File.read("saves/#{inputted}.json"))

    @secret_word = game_data['secret_word']
    @secret_word_letters = game_data['guessed_letters']
    @used_letters = game_data['used_letters']
    @turn = game_data['turn']

    File.delete("saves/#{inputted}.json") if File.exist?("saves/#{inputted}.json")

    puts "\nGame loaded."
    game_party(loaded: true)
  end
end

Hangman.new.launch
