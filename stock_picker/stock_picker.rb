# frozen_string_literal: true

def stock_picker(array)
  max_profit_value = 0
  max_profit = []

  array.each_with_index do |element, index|
    array[index..].each_with_index do |next_element, next_index|
      if (next_element - element) > max_profit_value
        max_profit_value = next_element - element
        max_profit = [index, next_index + 1]
      end
    end
  end

  max_profit
end

stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
# => [1, 4]
