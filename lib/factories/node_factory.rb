# frozen_string_literal: true

require_relative '../nodes/prop_node'
require_relative '../nodes/slot_node'
require_relative '../nodes/var_node'

module Antlers
  class NodeFactory
    class << self
      def branch_node(segment:)
        # TODO: Detect node type (slot, if, for loop).
        SlotNode.new(**segment)
      end

      def leaf_node(segment:)
        return VarNode.new(name: segment[:ivar]) if segment[:ivar]

        PropNode.new(name: segment[:leaf], props: segment[:props])
      end
    end
  end
end
