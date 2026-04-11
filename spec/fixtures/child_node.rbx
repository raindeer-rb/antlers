# frozen_string_literal: true

require 'low_node'

module RBX
  class ChildNode < LowNode
    def render(event:, ivar:)
      <strong>{ivar}</strong>
    end
  end
end
