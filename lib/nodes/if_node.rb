# frozen_string_literal: true

require_relative '../interfaces/branch_node'
require_relative '../modules/props'
require_relative '../modules/variables'

module Antlers
  class IfNode < BranchNode
    include Props
    include Variables

    DEF_KEY = :if_def
    END_KEY = :if_end

    def initialize(name:, value:, props: [], children: [])
      super(name:, props:, children:)

      @value = value
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      output = ''.dup

      if evaluate(name: @value, current_binding:)
        @children.each do |child|
          output += child.render(current_binding:, parent_binding:, slot_node:, metadata:) || ''
        end
      end

      output
    end

    class << self
      def match?(segment:)
        segment[DEF_KEY]
      end

      def build(segment:, **)
        new(name: segment[DEF_KEY], value: segment[DEF_KEY])
      end
    end
  end
end
