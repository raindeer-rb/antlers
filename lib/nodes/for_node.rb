# frozen_string_literal: true

require_relative '../interfaces/branch_node'
require_relative '../modules/props'
require_relative '../modules/variables'

module Antlers
  class ForNode < BranchNode
    include Props
    include Variables

    DEF_KEY = :for_def
    END_KEY = :for_end

    def initialize(name:, items:, value:, key: nil, props: [], children: [])
      super(name:, props:, children:)

      @items = items
      @value = value
      @key = key
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      output = ''

      evaluate(name: @items, current_binding:).each do |value|
        key, value = value if @key

        # TODO: Parallelize by creating new bindings and ensuring children have any args they need via RenderEvent.
        current_binding.local_variable_set(@value, value)
        current_binding.local_variable_set(@key, key) if @key

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
        value, key, items = segment.values_at(DEF_KEY, :key, :in)
        new(name: value, key:, value:, items:)
      end
    end
  end
end
