# frozen_string_literal: true

require_relative '../tic_tac_toe'

require 'stringio'

describe TicTacToe do
  subject(:game) do
    described_class.new
  end

  context '#create_board' do
    it 'creates empty board 3x3' do
      subject

      game.send(:create_board)

      expect(game.instance_variable_get(:@board)).to eq([[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]])
    end
  end

  context '#check_winner' do
    it 'returns true if fields in row belong one player ' do
      subject

      game.instance_variable_set(:@board, [["X", "X", "X"], [" ", " ", " "], [" ", " ", " "]])

      expect(game.send(:check_winner, 'X')).to eq(true)
      expect(game.send(:check_winner, 'O')).to eq(false)

      game.instance_variable_set(:@board, [[" ", " ", " "], ["O", "O", "O"], [" ", " ", " "]])

      expect(game.send(:check_winner, 'X')).to eq(false)
      expect(game.send(:check_winner, 'O')).to eq(true)

      game.instance_variable_set(:@board, [[" ", " ", " "], [" ", " ", " "], ["X", "X", "X"]])

      expect(game.send(:check_winner, 'X')).to eq(true)
      expect(game.send(:check_winner, 'O')).to eq(false)
    end

    it 'returns true if fields in column belong one player ' do
      subject

      game.instance_variable_set(:@board, [["X", " ", " "], ["X", " ", " "], ["X", " ", " "]])

      expect(game.send(:check_winner, 'X')).to eq(true)
      expect(game.send(:check_winner, 'O')).to eq(false)

      game.instance_variable_set(:@board, [[" ", "O", " "], [" ", "O", " "], [" ", "O", " "]])

      expect(game.send(:check_winner, 'X')).to eq(false)
      expect(game.send(:check_winner, 'O')).to eq(true)

      game.instance_variable_set(:@board, [[" ", " ", "X"], [" ", " ", "X"], [" ", " ", "X"]])

      expect(game.send(:check_winner, 'X')).to eq(true)
      expect(game.send(:check_winner, 'O')).to eq(false)
    end

    it 'returns true if fields in diagonal belong one player ' do
      subject

      game.instance_variable_set(:@board, [["X", " ", " "], [" ", "X", " "], [" ", " ", "X"]])

      expect(game.send(:check_winner, 'X')).to eq(true)
      expect(game.send(:check_winner, 'O')).to eq(false)

      game.instance_variable_set(:@board, [[" ", " ", "O"], [" ", "O", " "], ["O", " ", " "]])

      expect(game.send(:check_winner, 'X')).to eq(false)
      expect(game.send(:check_winner, 'O')).to eq(true)
    end
  end

  context '#board_filled?' do
    it 'returns true if all fields are filled' do
      subject

      game.instance_variable_set(:@board, [["X", "X", "X"], ["X", "X", "X"], ["X", "X", "X"]])

      expect(game.send(:board_filled?)).to eq(true)

      game.instance_variable_set(:@board, [["O", "O", "X"], ["X", "X", "O"], ["O", "X", "X"]])

      expect(game.send(:board_filled?)).to eq(true)
    end

    it 'returns false if at least one field is empty' do
      game.instance_variable_set(:@board, [["X", "X", "X"], ["X", " ", "X"], ["X", "X", "X"]])

      expect(game.send(:board_filled?)).to eq(false)

      game.instance_variable_set(:@board, [["O", "O", "X"], ["X", " ", "O"], ["O", "X", "X"]])

      expect(game.send(:board_filled?)).to eq(false)

      game.instance_variable_set(:@board, [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]])

      expect(game.send(:board_filled?)).to eq(false)
    end
  end

  context '#swap_players' do
    it 'changes the player after the turn' do
      subject

      expect(game.send(:swap_players, 'X')).to eq('O')
      expect(game.send(:swap_players, 'O')).to eq('X')
    end
  end
end
