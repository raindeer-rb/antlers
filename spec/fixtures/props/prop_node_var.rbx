# frozen_string_literal: true

require 'lownode'

module RBX
  class PropNodeVar < LowNode
    def render(var:)
      <strong>{var}</strong>
    end
  end
end
