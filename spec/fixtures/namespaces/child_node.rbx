# frozen_string_literal: true

require 'lownode'

class ChildNode < LowNode
  def render
    <{ LayoutNode: }>
      <p></p>
    <{ :LayoutNode }>
  end
end
