# frozen_string_literal: true

require 'lownode'

module RBX
  class ForNodeHash < LowNode
    def initialize
      @items = {
        one: 1,
        two: 2,
        three: 3,
      }
    end

    def render
      <ul>
        <{ for: key, value in: @items }>
          <li>{key}:{value}</li>
        <{ :for }>
      </ul>
    end
  end
end
