# frozen_string_literal: true

class TicTacToe
  def initialize
    @board = []
  end

  def launch
    create_board
    ramdom_player == 1 ? player = 'X' : player = 'O'

    loop do
      show_board
      puts "Player turn with symbol #{player}"
      puts 'Enter cell number(1-9):'
      cell = gets.chomp.to_i
      mark_cell(cell, player)

      if board_filled?
        puts 'Game over. Starting again.'
        @board = []
        launch
      end

      if check_winner(player)
        puts "Player with symbol #{player} - winner!"
        break
      end

      player = swap_players(player)
    end
    show_board
  end

  private

  def create_board
    3.times do
      row = []
      3.times do
        row.append(' ')
      end
      @board.append(row)
    end
  end

  def ramdom_player
    rand(0..1)
  end

  def mark_cell(number, player)
    row = nil
    column = nil

    if number <= 3
      row = 0
      column = number - 1
    elsif number >= 4 && number <= 6
      row = 1
      column = number - 4
    elsif number >= 7 && number <= 9
      row = 2
      column = number - 7
    end

    if cell_empty?(@board[row][column], player)
      @board[row][column] = player
    else
      puts 'Cell is not empty, choose another cell'
      cell = gets.chomp.to_i
      mark_cell(cell, player)
    end
  end

  def cell_empty?(cell, player)
    cell != swap_players(player)
  end

  def check_winner(player)
    win = nil
    n = @board.length

    @board.each_with_index do |row, row_index|
      win = true
      row.each_with_index do |_, column_index|
        if @board[row_index][column_index] != player
          win = false
          break
        end
      end

      return win if win
    end

    @board.each_with_index do |row, row_index|
      win = true
      row.each_with_index do |_, column_index|
        if @board[column_index][row_index] != player
          win = false
          break
        end
      end

      return win if win
    end

    win = true
    @board.each_with_index do |_, index|
      if @board[index][index] != player
        win = false
        break
      end
    end
    return win if win

    win = true
    @board.each_with_index do |_, index|
      if @board[index][n - 1 - index] != player
        win = false
        break
      end
    end
    return win if win

    @board.each do |row|
      row.each { |column| return false if column == ' ' }
    end

    true
  end

  def board_filled?
    @board.each do |row|
      row.each { |column| return false if column == ' ' }
    end

    true
  end

  def show_board
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        print column
        print '|' if column_index != @board.length - 1
      end
      puts "\n-+-+-" if row_index != @board.length - 1
    end
    puts ''
  end

  def swap_players(player)
    player == 'O' ? 'X' : 'O'
  end
end

TicTacToe.new.launch

