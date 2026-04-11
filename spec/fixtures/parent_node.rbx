# frozen_string_literal: true

require 'low_node'

module RBX
  class ParentNode < LowNode
    def initialize(event:)
      @ivar = 'Parent Variable'
    end

    def render(event:)
      <html><{ ChildNode ivar=@ivar }></html>
    end

    # Usuallly a low node instance calls an antlers node, passing in the instance's binding.
    # But in this unit test we call an antlers node directly and supply it our mock binding.
    def instance_binding = binding
  end
end
