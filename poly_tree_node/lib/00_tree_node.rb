require 'byebug'
class PolyTreeNode
  # attr_accessor :parent
  # attr_reader :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent)
    @parent.children.reject! { |child| child == self } unless @parent.nil?
    @parent = parent
    @parent.children << self unless @parent.nil?
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "NOT MY CHILD" unless @children.include?(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value

    @children.each do |child|
      val = child.dfs(target_value)
      return val unless val.nil?
    end
    nil
  end

  def bfs(target_value)
    que = [self]
    until que.empty? do
      node = que.shift
      return node if node.value == target_value
      que += node.children
    end
    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  a = PolyTreeNode.new('a')
  b = PolyTreeNode.new('b')
  c = PolyTreeNode.new('c')
  b.parent = a
  c.parent = a

  p a.dfs('c')
end
