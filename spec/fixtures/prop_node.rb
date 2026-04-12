# frozen_string_literal: true

require 'low_node'

module Ruby
  class PropNode < LowNode
    def initialize(event:)
      @ivar = 'Instance Variable'
    end

    def render(event:)
      @ivar
    end
  end
end
