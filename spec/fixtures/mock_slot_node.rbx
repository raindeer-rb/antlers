# frozen_string_literal: true

require 'low_node'

class MockSlotNode < LowNode
  def render(event:, **props)
    <header>Site Name</header>
    <{ :slot }>
    <footer>More Info</footer>
  end
end
