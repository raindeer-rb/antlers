# frozen_string_literal: true

require_relative '../nodes/prop_node'

module Antlers
  class SlotNode < PropNode
    attr_accessor :children

    def initialize(name:, props: [], children: [])
      super(name:, props:)

      @children = children
    end
  end
end
