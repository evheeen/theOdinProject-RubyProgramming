# frozen_string_literal: true

class Mastermind
  def initialize
    @secret_code = []
  end

  def launch
    puts 'This is Mastermind game. Choose the role:'
    puts '1 - if you want to be CODE BREACKER'
    puts '2 - if you want to be CODE MAKER'

    puts "\nq - to exit"

    choose = gets.chomp.strip

    return if choose == 'q'

    code_breacker_mod if choose == '1'
    code_maker_mod if choose == '2'
  end

  private

  def code_breacker_mod
    create_secret_code
    puts 'Computer has already created a secret code.'
    print @secret_code, "\n"

    game_result = breacker_game_party
    breacker_game_over(game_result)
  end

  def code_maker_mod
    set_secret_code

    game_result = maker_game_party
    maker_game_over(game_result)
  end

  # Cases
  def breacker_game_party
    puts 'You have 12 turns to guess the secret code.'
    12.times do |turn|
      puts "Turn ##{turn + 1}. Type in four numbers (1-6) to guess code."
      inputted_number = get_inputted_number.split('')

      existent_matches, complete_matches = found_matches(inputted_number.clone)
      show_matches(existent_matches, complete_matches)

      return turn if solved?(inputted_number)
    end

    return false
  end

  def maker_game_party
    numbers = %w[1 2 3 4 5 6].shuffle
    existent_matches = 0
    complete_matches = 0
    existent_matches_number = []
    used_combinations = []
    all_possible_combinations = nil

    12.times do |turn|
      sleep(0.2)
      puts "Computer turn ##{turn + 1}."
      if (existent_matches + complete_matches) != 4
        existent_matches_number.pop(4 - (existent_matches + complete_matches)) if turn != 0

        existent_matches_number.push(numbers[turn]) until existent_matches_number.length == 4
      else
        all_possible_combinations = possible_combinations(existent_matches_number, used_combinations) if all_possible_combinations.nil?

        existent_matches_number = all_possible_combinations[0]
        all_possible_combinations = all_possible_combinations[1..]
      end

      puts existent_matches_number.join

      existent_matches, complete_matches = found_matches(existent_matches_number.clone)
      show_matches(existent_matches, complete_matches)

      return turn if solved?(existent_matches_number)

      used_combinations.push([existent_matches_number.clone, complete_matches, existent_matches])
    end

    return false
  end

  # Solve functions
  def possible_combinations(existent_matches_number, used_combinations)
    all_possible_combinations = existent_matches_number.permutation.to_a.uniq

    used_combinations.each do |used_combination|
      all_possible_combinations.each do |possible_combination|
        existent_matches, complete_matches = found_matches(possible_combination.clone, used_combination[0])
        if existent_matches != used_combination[2] && complete_matches != used_combination[1]
          all_possible_combinations.delete_if { |combination| combination == possible_combination }
        end
      end
    end

    all_possible_combinations
  end

  # Breaker game over message
  def breacker_game_over(game_result)
    if game_result
      puts "\nThe Secret code was #{@secret_code.join()}"
      puts "You won, #{game_result + 1} turns were enough for you.\n\n"
    else
      puts "\nGame over. You didn't guess the secret code in 12 turns."
      puts "The Secret code was #{@secret_code.join()}\n\n"
    end

    launch
  end

  def maker_game_over(game_result)
    if game_result
      puts "\nThe Secret code was #{@secret_code.join()}"
      puts "Computer won, #{game_result + 1} turns were enough for him.\n\n"
    else
      puts "\nGame over. Computer didn't guess the secret code in 12 turns."
      puts "The Secret code was #{@secret_code.join()}\n\n"
    end

    launch
  end

  # Gues or set secret code
  def create_secret_code
    @secret_code = [rand(1..6).to_s, rand(1..6).to_s, rand(1..6).to_s, rand(1..6).to_s]
  end

  def get_inputted_number
    input = gets.chomp
    return input if input.match(/^[1-6]{4}$/)

    puts 'Input 4 digits between 1-6.'
    get_inputted_number
  end

  def set_secret_code
    puts 'Set the secret code'
    code = gets.chomp.strip
    return @secret_code = code.split('') if code.match(/^[1-6]{4}$/)

    puts 'Input 4 digits between 1-6.'
    set_secret_code
  end

  # Check if solved
  def solved?(inputted_number)
    @secret_code == inputted_number
  end

  # Matches
  def found_matches(inputted_number, code = nil)
    complete_matches = found_complete_matches(inputted_number, code)
    existent_matches = found_existent_matches(inputted_number, code)

    return existent_matches, complete_matches
  end

  def found_existent_matches(inputted_number, code = nil)
    secret_code = code.clone || @secret_code.clone
    matches = 0
    
    secret_code.each_with_index do |number, index|
      if number == inputted_number[index]
        inputted_number[index] = '-'
        secret_code[index] = '-'
      end
    end

    inputted_number.each_index do |index|
      if inputted_number[index] != '-' && secret_code.include?(inputted_number[index])
        matches += 1
        secret_code[secret_code.index(inputted_number[index])] = '-'
        inputted_number[index] = '-'
      end
    end

    matches
  end

  def found_complete_matches(inputted_number, code = nil)
    secret_code = code || @secret_code.clone

    matches = 0
    secret_code.each_with_index do |number, index|
      matches += 1 if number == inputted_number[index]
    end

    matches
  end

  def show_matches(existent_matches, complete_matches)
    print "\tMatches: "
    complete_matches.times { print '● ' }
    existent_matches.times { print '○ ' }
    puts ''
  end
end

Mastermind.new.launch
