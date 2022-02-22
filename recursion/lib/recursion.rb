# frozen_string_literal: true

def fibs(n, fib = [])
  first_num, second_num = [0, 1]
  fib.append(first_num)

  (n - 1).times do
    first_num, second_num = second_num, first_num + second_num
    fib.append(first_num)
  end

  fib
end

def fibs_rec(n, fib = [])
  if n <= 2
    (0...n).each { |i| fib.append(i) }
    return fib
  end

  fib = fibs_rec(n - 1)
  fib.append(fib[-2] + fib[-1])
end

fibs(100)
fibs_rec(100)

def merge_sort(to_sort)
  return to_sort if to_sort.length < 2

  mid = to_sort.length / 2
  left = merge_sort(to_sort[0...mid])
  right = merge_sort(to_sort[mid..])

  merge(left, right)
end

def merge(left, right, sorted = [])
  until left.empty? || right.empty?
    left[0] < right[0] ? sorted.append(left.shift) : sorted.append(right.shift)
  end

  sorted + left + right
end

to_sort = 20.times.map { rand(100) }
merge_sort(to_sort)
