# frozen_string_literal: true

require_relative '../nodes/prop_node'
require_relative '../nodes/slot_node'
require_relative '../nodes/var_node'
require_relative '../nodes/yield_node'

module Antlers
  class NodeFactory
    class << self
      def prop_node(segment:)
        PropNode.new(name: segment[:prop], props: segment[:props])
      end

      def slot_node(segment:)
        SlotNode.new(name: segment[:slot_def], props: segment[:props])
      end

      def var_node(segment:)
        VarNode.new(value: segment[:var])
      end

      def yield_node(segment:)
        YieldNode.new(name: segment[:slot])
      end
    end
  end
end
