# frozen_string_literal: true

require 'low_node'

module RBX
  class PropNodeVar < LowNode
    def render(event:, var:)
      <strong>{var}</strong>
    end
  end
end
