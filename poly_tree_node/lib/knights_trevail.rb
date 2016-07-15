require_relative '00_tree_node'

class KnightPathFinder
  attr_reader :root

  KNIGHTDELTAS = [
                  [2, -1],
                  [2, 1],
                  [1, -2],
                  [1, 2],
                  [-1, -2],
                  [-1, 2],
                  [-2, -1],
                  [-2, 1]
                ]

  def initialize(starting_position)
    @root = PolyTreeNode.new(starting_position)
    @visited = [starting_position]
  end

  def build_move_tree
    queue = [@root]

    until queue.empty?
      node = queue.shift
      position = node.value
      possible_positions = new_move_positions(position)
      possible_positions.map! do |pos|
        @visited << pos

        child = PolyTreeNode.new(pos)
        child.parent = node
        child
      end

      queue += possible_positions
    end
  end

  def new_move_positions(position)
    new_positions = KNIGHTDELTAS.map do |delta|
      d1, d2 = delta
      p1, p2 = position

      [p1 + d1, p2 + d2]
    end

    new_positions.select { |pos| valid_pos?(pos) && !visted_pos?(pos) }
  end

  def find_path(end_pos)
    target_node = @root.dfs(end_pos)
    trace_path(target_node)
  end

  def trace_path(node)
    path = []
    until node.parent.nil?
      path << node.value
      node = node.parent
    end
    path << node.value
  end

  def valid_pos?(pos)
    pos.all? { |num| num.between?(0, 7) }
  end

  def visted_pos?(pos)
    @visited.include? pos
  end
end

if __FILE__ == $PROGRAM_NAME
  kpf = KnightPathFinder.new([0,0])
  kpf.new_move_positions
end
