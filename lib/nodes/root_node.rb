# frozen_string_literal: true

require_relative '../interfaces/antler_node'

module Antlers
  class RootNode < AntlerNode
    attr_accessor :children

    def initialize(name: :root_node, children: [])
      super(name:)

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
