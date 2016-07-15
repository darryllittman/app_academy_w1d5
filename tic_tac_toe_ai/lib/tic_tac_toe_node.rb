require 'byebug'
require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_mover_mark = (@next_mover_mark == :x) ? :o : :x
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    opponent_mark = (evaluator == :x) ? :o : :x

    return true if @board.over? && @board.winner == opponent_mark
    return false if @board.over?

    evaluators_turn = @next_mover_mark == evaluator

    if evaluators_turn
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    opponent_mark = (evaluator == :x) ? :o : :x

    return true if @board.over? && @board.winner == evaluator
    return false if @board.over?

    evaluators_turn = @next_mover_mark == evaluator

    if evaluators_turn
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    spaces = [0, 1, 2].product([0, 1, 2])
    children = []
    spaces.each do |space|
      b = @board.dup

      if b[space].nil?
        b[space] = @next_mover_mark
        children << TicTacToeNode.new(b, @prev_mover_mark, space)
      end
    end

    children
  end
end

if $PROGRAM_NAME == __FILE__
  b = TicTacToeNode.new(Board.new, :x)
  b.board[[0, 0]] = :x
  b.board[[0, 1]] = :o
  p b.children.map { |child| child.prev_move_pos }
end
