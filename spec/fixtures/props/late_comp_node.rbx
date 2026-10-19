# frozen_string_literal: true

require 'lownode'

module RBX
  class LateCompNode < LowNode
    def initialize
      @ivar = 'Late Instance Variable'
    end

    def render
      <html>{@ivar}</html>
    end
  end
end
