# frozen_string_literal: true

require_relative '../nodes/prop_node'

module Antlers
  class SlotNode < PropNode
    attr_accessor :children

    def initialize(name:, props: [], children: [])
      super(name:, props:)

      @children = children
    end

    def render(caller_binding: nil)
      output = ''

      @children.each do |child|
        output += child.respond_to?(:render) ? child.render(caller_binding:) : child
      end

      output
    end
  end
end
