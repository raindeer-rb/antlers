# frozen_string_literal: true

require 'low_node'

module RBX
  class SlotNodeWithChild < LowNode
    def initialize(event:)
      @ivar = 'Parent Variable'
    end

    # Passes in prop from this instance, not from YieldNode.
    def render(event:)
      <{ YieldNode: }>
        <{ PropNodeVar var=@ivar }>
      <{ :YieldNode }>
    end
  end
end
