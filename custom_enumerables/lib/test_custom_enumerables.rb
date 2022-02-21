# frozen_string_literal: true

require_relative 'custom_enumerables'

def multiply_els(to_multiply)
  to_multiply.my_inject(:*)
end

puts multiply_els([2, 4, 5])
