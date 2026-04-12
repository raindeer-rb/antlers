# frozen_string_literal: true

module Ruby
  class PropNodeNoIvar < LowNode
    def render(event:)
      @ivar
    end
  end
end
