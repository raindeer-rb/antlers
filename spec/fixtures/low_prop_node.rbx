# frozen_string_literal: true

require 'low_node'

module RBX
  class LowPropNode < LowNode
    def initialize(event:)
      @ivar = 'Instance Variable'
    end

    def render(event:)
      <html>{@ivar}</html>
    end
  end
end
