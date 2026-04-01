# frozen_string_literal: true

require_relative 'factories/node_factory'
require_relative 'nodes/root_node'

module Antlers
  module Parser
    class << self
      def parse(sequence, id: :render)
        branch(branch_node: RootNode.new(name: id), sequence:)
      end

      def branch(branch_node:, sequence:)
        until sequence.empty?
          segment = sequence.shift

          if segment.is_a?(String)
            branch_node.children << segment
          elsif segment[:prop] || segment[:ivar]
            branch_node.children << NodeFactory.leaf_node(segment:)
          # TODO: This path not called/tested/fully implemented yet.
          elsif segment[:branch]
            next_branch = NodeFactory.branch_node(segment:)
            branch_node.children << next_branch

            branch(branch_node: next_branch, sequence:)
          end
        end

        branch_node
      end
    end
  end
end
