# frozen_string_literal: true

def bubble_sort(array)
  n = array.length

  loop do
    swapped = false

    (1..n - 1).each do |element|
      if array[element - 1] > array[element]
        array[element - 1], array[element] = array[element], array[element - 1]
        swapped = true
      end
    end

    break unless swapped
  end

  n -= 1

  array
end

bubble_sort([4, 3, 78, 2, 0, 2])
# => [0, 2, 2, 3, 4, 78]
