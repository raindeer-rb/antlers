# frozen_string_literal: true

require_relative '../interfaces/antler_node'

module Antlers
  class RootNode < AntlerNode
    attr_accessor :children

    def initialize(name: :root_node, children: [])
      super(name:)

      @children = children
    end
  end
end
