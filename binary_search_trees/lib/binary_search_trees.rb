# frozen_string_literal: true

require_relative 'node'

class Tree
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return nil if array.empty?

    mediana = (array.size - 1) / 2

    root       = Node.new(array[mediana])
    root.left  = build_tree(array[0...mediana])
    root.right = build_tree(array[mediana + 1..])

    root
  end

  def insert(value, node = root)
    return nil if node.data == value

    if node.data > value
      return node.left = Node.new(value) if node.left.nil?

      insert(value, node.left)
    else
      return node.right = Node.new(value) if node.right.nil?

      insert(value, node.right)
    end
  end

  def delete(value, node = root)
    return node if node.nil?

    node.left  = delete(value, node.left) if node.data > value
    node.right = delete(value, node.right) if node.data < value
    
    if node.data == value
      return node.left if node.left.nil?
      return node.right if node.right.nil?

      temp = smallest_leaf(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end

    node
  end

  def smallest_leaf(node)
    node = node.left until node.left.nil?

    node
  end

  def find(value, node = root)
    return node if node.nil?
    return node if node.data = value

    return find(value, node.left) if node.data > value
    return find(value, node.right) if node.data < value
  end

  def level_order(node = root, queue = [])
    return node if node.nil?

    print node.data, ' '

    queue.append(node.left) if node.left != nil
    queue.append(node.right) if node.right != nil

    level_order(queue.shift, queue)
  end

  def inorder(node = root)
    return nil if node.nil?

    inorder(node.left)
    print node.data, ' '
    inorder(node.right)
  end

  def preorder(node = root)
    return nil if node.nil?

    print node.data, ' '
    preorder(node.left)
    preorder(node.right)
  end

  def postorder(node = root)
    return nil if node.nil?

    postorder(node.left)
    postorder(node.right)
    print node.data, ' '
  end

  def height(node = root)
    return 0 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  def depth(node = root)
    return 0 if node.nil?

    left = depth(node.left)
    right = depth(node.right)

    return left + 1 if left > right
    return right + 1
  end

  def balanced?(node = root)
    return true if node.nil?

    left = height(node.left)
    right = height(node.right)

    return true if (left - right).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    
    false
  end

  def rebalance
    self.data = refresh_data
    self.root = build_tree(data)
  end

  def refresh_data(node = root, data = [])
    return nil if node.nil?

    refresh_data(node.left, data)
    data.append(node.data)
    refresh_data(node.right, data)

    data
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end


tree = Tree.new(15.times.map { rand(1..100) })
puts "#balanced? #{tree.balanced?}"
puts "#level_order #{tree.level_order}"
puts "#inorder #{tree.inorder}"
puts "#preorder #{tree.preorder}"
puts "#postorder #{tree.postorder}"

puts "\n#insert(110)"
tree.insert(110)
puts "#balanced? #{tree.balanced?}"
puts '#insert(120)'
tree.insert(120)
puts "#balanced? #{tree.balanced?}"

puts "\n#rebalance"
tree.rebalance
puts "#balanced? #{tree.balanced?}"
puts "#level_order #{tree.level_order}"
puts "#inorder #{tree.inorder}"
puts "#preorder #{tree.preorder}"
puts "#postorder #{tree.postorder}"

puts ''
tree.pretty_print
