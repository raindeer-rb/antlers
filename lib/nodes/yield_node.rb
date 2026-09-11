# frozen_string_literal: true

require_relative '../interfaces/leaf_node'

module Antlers
  class YieldNode < BranchNode
    def initialize(name: :default)
      super(name:)
    end

    # Render the children in the binding of the parent.
    def render(current_binding: nil, parent_binding:, slot_node:, metadata: {})
      output = ''

      slot_node.children.each do |child|
        output += child.render(current_binding: parent_binding, parent_binding:, slot_node:, metadata:) || ''
      end

      output
    end

    class << self
      def match?(segment:)
        segment[:slot]
      end

      def build(segment:, **)
        new(name: segment[:slot])
      end
    end
  end
end
