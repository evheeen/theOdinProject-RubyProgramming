# frozen_string_literal: true

ALFABET = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].freeze

def caesar_cipher(message, key)
  message.chars.map! { |symbol| shift_symbol(symbol, key) }.join
end

def shift_symbol(symbol, key)
  if ALFABET.include? symbol.upcase
    upper?(symbol) ? shift(symbol, key) : shift(symbol, key).downcase
  else
    symbol
  end
end

def shift(letter, key)
  step = (ALFABET.index(letter.upcase) + key) % ALFABET.length

  ALFABET[step]
end

def upper?(letter)
  letter == letter.upcase
end

caesar_cipher('What a string!', 5)
# => "Bmfy f xywnsl!"
