# frozen_string_literal: true

require_relative 'antler_node'

module Antlers
  class BranchNode < AntlerNode
    attr_accessor :children

    def initialize(name:, children: [])
      super(name:)

      @children = children
    end

    def render(current_binding:, parent_binding: nil, namespace: nil)
      output = ''

      @children.each do |child|
        # Antlers nodes respond to "render", whereas HTML is stored as a string and output as is.
        output += (child.respond_to?(:render) ? child.render(current_binding:, parent_binding:, namespace:) : child) || ''
      end

      output
    end
  end
end
