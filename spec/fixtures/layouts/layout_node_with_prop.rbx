# frozen_string_literal: true

require 'lownode'

module RBX
  class LayoutNodeWithProp < LowNode
    def render(event:, emotion:)
      <html>
        {"Layout"}
        {emotion}
        <{ :slot }>
      </html>
    end
  end
end
