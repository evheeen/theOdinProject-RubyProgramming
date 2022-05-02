# frozen_string_literal: true

require_relative '../lib/tdd_connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }

  context '#create_board' do
    let(:board) do
      [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ']]
    end

    it 'creates empty board 7x6' do
      subject

      game.send(:create_board)

      expect(game.instance_variable_get(:@board)).to eq(board)
    end
  end

  context '#check_winner' do
    it 'returns true if four fields in row belong one player ' do
      subject

      game.instance_variable_set(
        :@board,
        [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         ['●', '●', '●', ' ', ' ', ' ', ' '],
         ['○', '○', '○', '○', ' ', ' ', ' ']]
      )

      expect(game.send(:check_winner, '●')).to eq(false)
      expect(game.send(:check_winner, '○')).to eq(true)
    end

    it 'returns true if four fields in column belong one player ' do
      subject

      game.instance_variable_set(
        :@board,
        [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', '●', ' '],
         [' ', ' ', ' ', ' ', ' ', '●', '○'],
         [' ', ' ', ' ', ' ', ' ', '●', '○'],
         [' ', ' ', ' ', ' ', ' ', '●', '○']]
      )

      expect(game.send(:check_winner, '●')).to eq(true)
      expect(game.send(:check_winner, '○')).to eq(false)
    end

    it 'returns true if four fields in diagonal belong one player ' do
      subject

      game.instance_variable_set(
        :@board,
        [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', '●', ' ', ' ', ' ', ' ', ' '],
         ['●', '○', '●', '○', '●', '○', '●'],
         ['○', '●', '○', '●', '○', '●', '○'],
         ['●', '○', '●', '○', '●', '○', '●']]
      )

      expect(game.send(:check_winner, '●')).to eq(true)
      expect(game.send(:check_winner, '○')).to eq(false)

      game.instance_variable_set(
        :@board,
        [[' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', '●', ' '],
         ['●', '○', '●', '○', '●', '○', '●'],
         ['○', '●', '○', '●', '○', '●', '○'],
         ['●', '○', '●', '○', '●', '○', '●']]
      )

      expect(game.send(:check_winner, '●')).to eq(true)
      expect(game.send(:check_winner, '○')).to eq(false)
    end
  end

  context '#swap_players' do
    it 'changes the player after the turn' do
      subject

      expect(game.send(:swap_players, '●')).to eq('○')
      expect(game.send(:swap_players, '○')).to eq('●')
    end
  end
end
