# frozen_string_literal: true

require 'lownode'

module RBX
  class IfNode < LowNode
    def initialize(event:, boolean:)
      @boolean = boolean
    end

    def render
      <{ if: @boolean }>
        <p>Yes</p>
      <{ :if }>
    end
  end
end
