# frozen_string_literal: true

# Plain Ruby classes, not LowNodes, which Lowkey hasn't loaded.
module Simple
  # Takes a prop in initialize and another in render.
  class PropNode
    def initialize(limit: 5)
      @limit = limit
    end

    def render(suffix: '')
      "#{@limit}#{suffix}"
    end
  end

  # Takes its slot's rendered children in render.
  class SlotNode
    def initialize(title: nil)
      @title = title
    end

    def render(slot: nil)
      "<section title=\"#{@title}\">#{slot}</section>"
    end
  end
end
