# frozen_string_literal: true

require 'lownode'

module RBX
  class LayoutNode < LowNode
    def render
      <html>
        <{ :slot }>
      </html>
    end
  end
end
