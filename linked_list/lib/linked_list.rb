# frozen_string_literal: true

require_relative 'node'

class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    node = Node.new(value)

    @tail.next_node = node unless @tail.nil?
    @tail = node
    @head = node if @head.nil?
  end

  def prepend(value)
    node = Node.new(value)

    node.next_node = @head unless @head.nil?
    @head = node
    @tail = node if @tail.nil?
  end

  def size
    counter = 0

    node = @head
    until node.nil?
      counter += 1
      node = node.next_node
    end

    counter
  end

  def at(index)
    node = @head

    index.times { node = node.next_node }

    node
  end

  def pop
    nil if @head.nil?

    node = @head

    until node.next_node == @tail
      node = node.next_node
    end

    node.next_node = nil
    @tail = node
  end

  def contains?(value)
    node = @head

    size.times do
      return true if node.data == value

      node = node.next_node
    end

    false
  end

  def find(value)
    node = @head
    size.times do |index|
      return index if node.data == value

      node = node.next_node
    end

    nil
  end

  def to_s
    head = @head
    nodes = []

    until head.nil?
      nodes.push(head.data)
      head = head.next_node
    end

    puts nodes.join(' -> ') + ' -> nil'
  end

  def insert_at(value, index)
    return if index > size
    return prepend(value) if index.zero?

    node = Node.new(value, at(index))
    at(index - 1).next_node = node
    @tail = node if node.next_node.nil?
  end

  def remove_at(index)
    return if index > size

    return pop if index == size
    return @head = at(1) if index.zero?
    return at(index - 1).next_node = at(index + 1) if at(index) != @tail

    @tail = at(index - 1)
    @tail.next_node = nil
  end
end
