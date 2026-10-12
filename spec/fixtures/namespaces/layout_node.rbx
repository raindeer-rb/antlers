# frozen_string_literal: true

require 'lownode'

class LayoutNode < LowNode
  def render
    <html class="without-namespace">
      <{ :slot }>
    </html>
  end
end
