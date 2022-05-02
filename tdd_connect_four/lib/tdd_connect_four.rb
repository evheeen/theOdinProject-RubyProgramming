# frozen_string_literal: true

class ConnectFour
  def initialize
    @board = []
  end

  def launch
    create_board
    ramdom_player == 1 ? player = '●' : player = '○'

    loop do
      show_board
      puts "Player turn with symbol #{player}"
      puts 'Enter column number(1-7):'

      column = get_column

      mark_cell(column, player)

      if check_winner(player)
        puts "Player with symbol #{player} - winner!"
        break
      end

      if board_filled?
        puts 'Game over. Starting again.'
        @board = []

        launch
      end

      player = swap_players(player)
    end

    show_board
  end

  private

  def create_board
    6.times do
      row = []
      7.times do
        row.append(' ')
      end
      @board.append(row)
    end
  end

  def ramdom_player
    rand(0..1)
  end

  def mark_cell(column, player)
    @board.reverse_each do |row|
      next if row[column - 1] != ' '

      return row[column - 1] = player
    end
  end

  def check_winner(player)
    @board.each_with_index do |row, row_index|
      row.each_with_index do |_, column_index|
        next if column_index > 3

        return true if @board[row_index][column_index] == player &&
                       @board[row_index][column_index + 1] == player &&
                       @board[row_index][column_index + 2] == player &&
                       @board[row_index][column_index + 3] == player
      end
    end

    @board.each_with_index do |row, row_index|
      next if row_index > 2

      row.each_with_index do |_, column_index|
        return true if @board[row_index][column_index] == player &&
                       @board[row_index + 1][column_index] == player &&
                       @board[row_index + 2][column_index] == player &&
                       @board[row_index + 3][column_index] == player
      end
    end

    @board.each_with_index do |row, row_index|
      next if row_index > 2

      row.each_with_index do |_, column_index|
        next if column_index > 3

        return true if @board[row_index][column_index] == player &&
                       @board[row_index + 1][column_index + 1] == player &&
                       @board[row_index + 2][column_index + 2] == player &&
                       @board[row_index + 3][column_index + 3] == player
      end
    end

    @board.each_with_index do |row, row_index|
      next if row_index > 2

      row.each_with_index do |_, column_index|
        next if column_index < 3

        return true if @board[row_index][column_index] == player &&
                       @board[row_index + 1][column_index - 1] == player &&
                       @board[row_index + 2][column_index - 2] == player &&
                       @board[row_index + 3][column_index - 3] == player
      end
    end

    false
  end

  def board_filled?
    @board.each do |row|
      row.each { |column| return false if column == ' ' }
    end

    true
  end

  def get_column
    column = gets.chomp.gsub(/[^1-7]/, '')

    if column == ''
      puts 'Invalid input. Enter number in range 1-7.'
      return get_column
    end

    if @board[0][column.to_i - 1] != ' '
      puts 'Invalid input. Column is full.'
      return get_column
    end

    column.to_i
  end

  def show_board
    @board.each do |row|
      puts row.join(' ')
    end

    puts '1 2 3 4 5 6 7'
  end

  def swap_players(player)
    player == '○' ? '●' : '○'
  end
end

# ConnectFour.new.launch
