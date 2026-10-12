# frozen_string_literal: true

require 'lownode'

module Namespace
  class LayoutNode < LowNode
    def render
      <html class="with-namespace">
        <{ :slot }>
      </html>
    end
  end
end
