# frozen_string_literal: true

require 'lownode'

module Ruby
  class PropNode < LowNode
    def initialize
      @ivar = 'Instance Variable'
    end

    def render
      @ivar
    end
  end
end
