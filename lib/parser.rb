# frozen_string_literal: true

require_relative 'factories/node_factory'
require_relative 'nodes/root_node'

module Antlers
  module Parser
    class << self
      def parse(sequence, id: :root_node)
        branch(branch_node: RootNode.new(name: id), sequence:)
      end

      def branch(branch_node:, sequence:) # rubocop:disable Metrics/AbcSize
        until sequence.empty?
          segment = sequence.shift

          if segment.is_a?(String)
            branch_node.children << segment
          elsif segment[:var]
            branch_node.children << NodeFactory.var_node(segment:)
          elsif segment[:prop]
            branch_node.children << NodeFactory.prop_node(segment:)
          elsif segment[:slot_def]
            slot_node = NodeFactory.slot_node(segment:)
            branch_node.children << slot_node

            sub_sequence = []
            sub_sequence << sequence.shift until sequence.first[:slot_end] == slot_node.name

            branch(branch_node: slot_node, sequence: sub_sequence)
          end
        end

        branch_node
      end
    end
  end
end
