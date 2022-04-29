# frozen_string_literal: true

require_relative '../caesar_cipher'

describe '#caesar_cipher' do
  it 'encrypts default string' do
    expect(caesar_cipher('what a string', 5)).to eq('bmfy f xywnsl')
  end

  it 'encrypts and keeps the same case' do
    expect(caesar_cipher('What A String', 5)).to eq('Bmfy F Xywnsl')
  end

  it 'encrypts with different key' do
    expect(caesar_cipher('AbCdEf', 1)).to eq('BcDeFg')
    expect(caesar_cipher('AbCdEf', 26)).to eq('AbCdEf')
    expect(caesar_cipher('AbCdEf', 27)).to eq('BcDeFg')
  end

  it 'encrypts with different characters' do
    expect(caesar_cipher('A b C d E f', 10)).to eq('K l M n O p')
    expect(caesar_cipher('A-b+C!d)E(f@G#h$I&j%K', 20)).to eq('U-v+W!x)Y(z@A#b$C&d%E')
  end
end

describe '#shift' do
  it 'encrypts letter with different key' do
    expect(shift('A', 1)).to eq('B')
    expect(shift('A', 26)).to eq('A')
    expect(shift('A', 27)).to eq('B')
    expect(shift('b', 1)).to eq('C')
    expect(shift('b', 26)).to eq('B')
    expect(shift('b', 27)).to eq('C')
  end
end

describe '#upper?' do
  it 'returns true if letter is upper' do
    expect(upper?('A')).to eq(true)
    expect(upper?('C')).to eq(true)
    expect(upper?('D')).to eq(true)
  end

  it 'returns false if letter is lower' do
    expect(upper?('a')).to eq(false)
    expect(upper?('c')).to eq(false)
    expect(upper?('d')).to eq(false)
  end
end
