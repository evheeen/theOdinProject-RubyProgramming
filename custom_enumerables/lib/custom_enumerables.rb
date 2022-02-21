# frozen_string_literal: true

module Enumerable
  def my_each
    for i in self do
      yield i
    end

    self
  end

  def my_each_with_index(*args)
    index = 0

    for i in self do
      yield i, index
      index += 1
    end

    self
  end

  def my_select
    selected = []
    my_each { |i| selected.append(i) if yield i }

    selected
  end

  def my_all?
    my_each { |i| return false unless yield i }

    true
  end

  def my_any?
    my_each { |i| return true if yield i }

    false
  end

  def my_none?
    my_each { |i| return false if yield i }

    true
  end

  def my_count
    return length unless block_given?

    counter = 0
    my_each { |i| counter += 1 if yield i }

    counter
  end

  def my_map(block = nil)
    mapped = []
    proc_or_block = block ? ->(i) { block.call(i) } : ->(i) { yield (i) }
    my_each { |i| mapped.append(proc_or_block.call(i)) }

    mapped
  end

  def my_inject(*args)
    case args
    in [i] if i.is_a? Symbol
      symbol = i
    in [i] if i.is_a? Object
      object = i
    in [i, j]
      object = i
      symbol = j
    else
      object = nil
      symbol = nil
    end

    injected = object || first

    if block_given?
      my_each_with_index { |i, index| injected = yield(injected, i) }
    elsif symbol
      my_each_with_index do |i, index|
        next if object.nil? && index.zero?

        injected = injected.send(symbol, i)
      end
    end

    injected
  end
end
