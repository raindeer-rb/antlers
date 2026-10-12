# frozen_string_literal: true

require 'lownode'
require_relative '../../../lib/antlers'

module RBX
  class SlotNodeWithProp < LowNode
    def render
      <{ LayoutNodeWithProp: emotion='Happy' }>
        {"Yield"}
      <{ :LayoutNodeWithProp }>
    end
  end
end
