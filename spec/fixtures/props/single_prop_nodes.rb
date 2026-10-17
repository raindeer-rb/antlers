# frozen_string_literal: true

require 'lownode'

module Ruby
  # Takes one prop in initialize.
  class InitializePropNode < LowNode
    def initialize(limit: 5)
      super()
      @limit = limit
    end

    def render
      "#{@limit.inspect} (#{@limit.class})"
    end
  end

  # Takes one prop in render.
  class RenderPropNode < LowNode
    def render(limit: 5)
      "#{limit.inspect} (#{limit.class})"
    end
  end
end
