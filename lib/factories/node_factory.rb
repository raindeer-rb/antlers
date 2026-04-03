# frozen_string_literal: true

require_relative '../nodes/prop_node'
require_relative '../nodes/slot_node'
require_relative '../nodes/var_node'

module Antlers
  class NodeFactory
    class << self
      def var_node(segment:)
        VarNode.new(name: segment[:var])
      end

      def prop_node(segment:)
        PropNode.new(name: segment[:prop], props: segment[:props])
      end

      def slot_node(segment:)
        SlotNode.new(name: segment[:slot_def], props: segment[:props])
      end
    end
  end
end
