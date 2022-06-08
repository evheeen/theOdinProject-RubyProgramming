# frozen_string_literal: true

require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/rook'
require_relative '../../lib/board'

describe Rook do
  let(:board) { Board.new }
  let(:black) { instance_double(Piece, color: :black) }
  let(:white) { instance_double(Piece, color: :white) }

  context '#possible_moves' do
    subject(:rook) { described_class.new(board, { position: [2, 2], color: :white }) }

    context 'if board empty' do
      it 'has moves' do
        expect(subject.possible_moves(board)).to eq([[3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [2, 1], [2, 0], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [1, 2], [0, 2]])
      end
    end

    context 'if board filled with enemy pieces' do
      let(:table) do
        [[black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, subject, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black]]
      end

      it 'has not moves' do
        allow(board).to receive(:table).and_return(table)

        expect(subject.possible_moves(board)).to eq([])
      end
    end

    context 'if board filled with friend pieces' do
      let(:table) do
        [[white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, subject, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white]]
      end

      it 'has not moves' do
        allow(board).to receive(:table).and_return(table)

        expect(subject.possible_moves(board)).to eq([])
      end
    end
  end

  context '#possible_captures' do
    subject(:rook) { described_class.new(board, { position: [2, 2], color: :white }) }

    context 'if board empty' do
      it 'has not captures' do
        expect(subject.possible_captures(board)).to eq([])
      end
    end

    context 'if board filled with enemy pieces' do
      let(:table) do
        [[black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, subject, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black],
         [black, black, black, black, black, black, black, black]]
      end

      it 'has captures' do
        allow(board).to receive(:table).and_return(table)

        expect(subject.possible_captures(board)).to eq([[3, 2], [2, 1], [2, 3], [1, 2]])
      end
    end

    context 'if board filled with friend pieces' do
      let(:table) do
        [[white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, subject, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white],
         [white, white, white, white, white, white, white, white]]
      end

      it 'has not captures' do
        allow(board).to receive(:table).and_return(table)

        expect(subject.possible_captures(board)).to eq([])
      end
    end

    context 'if board filled with friend and enemy pieces' do
      let(:table) do
        [[black, white, white, white, white, white, white, white],
         [black, black, white, white, white, white, white, white],
         [black, black, subject, white, white, white, white, white],
         [black, black, black, black, white, white, white, white],
         [black, black, black, black, black, white, white, white],
         [black, black, black, black, black, black, white, white],
         [black, black, black, black, black, black, black, white],
         [black, black, black, black, black, black, black, black]]
      end

      it 'has not captures' do
        allow(board).to receive(:table).and_return(table)

        expect(subject.possible_captures(board)).to eq([[3, 2], [2, 1]])
      end
    end
  end
end
