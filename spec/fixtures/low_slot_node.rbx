# frozen_string_literal: true

require 'low_node'

module Low
  class SlotNode < LowNode
    def render(event:, **props)
      <header>Site Name</header>
      <{ :slot }>
      <footer>More Info</footer>
    end
  end
end
