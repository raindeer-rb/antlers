# frozen_string_literal: true

require 'lownode'

module Namespace
  class ChildNode < LowNode
    def render
      <{ LayoutNode: }>
        <p></p>
      <{ :LayoutNode }>
    end
  end
end
